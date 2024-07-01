import UIKit
import WidgetKit
import CoreData
import UserNotifications

// CoreData 함수용 Manager 싱글톤
class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {
        // 요청 알림 권한
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    // Core Data persistent container 초기화
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Challendar")
        
        // 앱 그룹 디렉토리 설정
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.seungwon.ChallendarGroup") else {
            fatalError("Failed to get app group container URL")
        }
        let storeURL = appGroupURL.appendingPathComponent("Challendar.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        // CloudKit 및 CoreData 설정
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        // CloudKit 컨테이너 식별자 설정
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.seungwon.Challendar")
        
        container.persistentStoreDescriptions = [description]
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // 원격 변경 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(storeRemoteChange(_:)), name: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator)
        
        return container
    }()
    
    // Core Data context 반환
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 변경 토큰을 저장할 변수
    private var lastHistoryToken: NSPersistentHistoryToken? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "lastHistoryToken") else { return nil }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: data)
        }
        set {
            guard let token = newValue else { return }
            let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: "lastHistoryToken")
        }
    }
    
    // 원격 변경 알림 처리
    @objc private func storeRemoteChange(_ notification: Notification) {
        fetchHistoryAndUpdateContext()
    }
    
    // 앱 시작 시 동기화 트리거
    func triggerSync() {
        fetchHistoryAndUpdateContext()
    }
    func resetHistoryToken() {
        UserDefaults.standard.removeObject(forKey: "lastHistoryToken")
    }
    // 변경 사항 가져와서 컨텍스트 업데이트
    private func fetchHistoryAndUpdateContext() {
        context.perform {
            do {
                // 히스토리 토큰이 유효하지 않을 경우 초기화
                if self.lastHistoryToken == nil {
                    self.resetHistoryToken()
                }

                let fetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastHistoryToken)
                if let historyResult = try self.context.execute(fetchRequest) as? NSPersistentHistoryResult,
                   let transactions = historyResult.result as? [NSPersistentHistoryTransaction] {
                    for transaction in transactions {
                        self.context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                    }
                    self.lastHistoryToken = transactions.last?.token
                }
                try self.context.save()
                NotificationCenter.default.post(name: NSNotification.Name("CoreDataChanged"), object: nil)
                DispatchQueue.main.async {
                    WidgetCenter.shared.reloadTimelines(ofKind: "ChallendarWidget")
                }
            } catch {
                print("Failed to process remote change notification: \(error)")
                // 오류가 발생하면 히스토리 토큰을 재설정
                self.resetHistoryToken()
            }
        }
    }
    
    // 로컬 알림 생성 메서드
    func sendLocalNotification(title: String, body: String, triggerDate: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled with identifier: \(identifier)")
            }
        }
    }
    
    func scheduleNotificationsForTodo(todo: Todo) {
        guard let reminderTime = todo.reminderTime else { return }
        let calendar = Calendar.current

        var notificationIdentifiers = [String]()
        
        for (date, _) in todo.completed {
            var reminderDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            let reminderTimeComponents = calendar.dateComponents([.hour, .minute], from: reminderTime)
            reminderDateComponents.hour = reminderTimeComponents.hour
            reminderDateComponents.minute = reminderTimeComponents.minute

            if let finalReminderDate = calendar.date(from: reminderDateComponents) {
                let identifier = "Todo_\(todo.id?.uuidString ?? UUID().uuidString)_\(date)"
                notificationIdentifiers.append(identifier)
                sendLocalNotification(
                    title: "\(todo.title)를 수행해야해요!",
                    body: todo.isChallenge ? "오늘의 챌린지를 지금 바로 확인해보세요!" : "오늘의 계획을 지금 바로 확인해보세요!",
                    triggerDate: finalReminderDate,
                    identifier: identifier
                )
            }
        }

        if let todoID = todo.id, let todoModel = fetchTodoById(id: todoID) {
            todoModel.notificationIdentifiers = notificationIdentifiers
            saveContext()
        }
    }
    
    // CRUD Operations
    
    // Create
    public func createTodo(newTodo: Todo) {
        context.perform {
            let todo = TodoModel(context: self.context)
            todo.id = UUID()
            todo.title = newTodo.title
            todo.memo = newTodo.memo
            todo.startDate = newTodo.startDate
            todo.endDate = newTodo.endDate
            todo.completed = newTodo.completed
            todo.repetition = newTodo.repetition
            todo.reminderTime = newTodo.reminderTime
            todo.isChallenge = newTodo.isChallenge
            todo.percentage = newTodo.percentage
            if let imagesArray = newTodo.images {
                let imageData = imagesArray.map { $0.pngData() }
                todo.images = try? JSONEncoder().encode(imageData)
            }
            todo.isCompleted = newTodo.iscompleted
            self.saveContext()
        }
        scheduleNotificationsForTodo(todo: newTodo)
    }
    
    // Save context
    func saveContext() {
        context.perform {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("CoreDataChanged"), object: nil, userInfo: nil)
                    }
                } catch {
                    if let nserror = error as NSError? {
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
    }
    
    // Read
    func fetchTodos() -> [Todo] {
        var todos: [Todo] = []
        context.performAndWait {
            let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            let dateOrder = NSSortDescriptor(key: "startDate", ascending: false)
            fetchRequest.sortDescriptors = [dateOrder]
            
            do {
                let todoModels = try self.context.fetch(fetchRequest)
                todos = todoModels.map { model in
                    let images: [UIImage]? = {
                        if let imageData = model.images, let decodedData = try? JSONDecoder().decode([Data].self, from: imageData) {
                            return decodedData.compactMap { UIImage(data: $0) }
                        }
                        return []
                    }()
                    return Todo(
                        id: model.id,
                        title: model.title,
                        memo: model.memo,
                        startDate: model.startDate,
                        endDate: model.endDate,
                        completed: model.completed,
                        isChallenge: model.isChallenge,
                        percentage: model.percentage,
                        images: images,
                        iscompleted: model.isCompleted,
                        repetition: model.repetition,
                        reminderTime: model.reminderTime
                    )
                }
            } catch {
                print("Failed to fetch todos: \(error)")
            }
        }
        return todos
    }
    
    func fetchTodoById(id: UUID) -> TodoModel? {
        var todo: TodoModel?
        context.performAndWait {
            let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let todos = try self.context.fetch(fetchRequest)
                todo = todos.first
            } catch {
                print("Failed to fetch todo by id: \(error)")
            }
        }
        return todo
    }
    
    // Update
    func updateTodoById(id: UUID, newTitle: String? = nil, newMemo: String? = nil, newStartDate: Date? = nil, newEndDate: Date? = nil, newCompleted: [Date: Bool]? = nil, newIsChallenge: Bool? = nil, newPercentage: Double? = nil, newImages: [UIImage]? = nil, newIsCompleted: Bool? = nil, newRepetition: [Int]? = nil, newReminderTime: Date? = nil) {
        guard let todoToUpdate = fetchTodoById(id: id) else {
            print("Todo not found")
            return
        }
        
        if let newTitle = newTitle {
            todoToUpdate.title = newTitle
        }
        if let newMemo = newMemo {
            todoToUpdate.memo = newMemo
        }
        if let newStartDate = newStartDate {
            todoToUpdate.startDate = newStartDate
        }
        if let newEndDate = newEndDate {
            todoToUpdate.endDate = newEndDate
        }
        if let newCompleted = newCompleted {
            todoToUpdate.completed = newCompleted
            todoToUpdate.percentage = Double(newCompleted.filter{$0.value == true}.count) / Double(newCompleted.count)
        }
        if let newIsChallenge = newIsChallenge {
            todoToUpdate.isChallenge = newIsChallenge
        }
        if let newPercentage = newPercentage {
            todoToUpdate.percentage = newPercentage
        }
        if let newImages = newImages {
            let imageData = newImages.map { $0.pngData() }
            todoToUpdate.images = try? JSONEncoder().encode(imageData)
        }
        if let newIsCompleted = newIsCompleted {
            todoToUpdate.isCompleted = newIsCompleted
        }
        if let newRepetition = newRepetition {
            todoToUpdate.repetition = newRepetition
        }
        todoToUpdate.reminderTime = newReminderTime
        
        saveContext()
        
        removeNotificationsForTodoId(id: id)
        if let todo = convertTodoModelToTodo(todoToUpdate) {
            scheduleNotificationsForTodo(todo: todo)
        }
    }
    
    func convertTodoModelToTodo(_ model: TodoModel) -> Todo? {
        let images: [UIImage]? = {
            if let imageData = model.images, let decodedData = try? JSONDecoder().decode([Data].self, from: imageData) {
                return decodedData.compactMap { UIImage(data: $0) }
            }
            return []
        }()
        return Todo(
            id: model.id,
            title: model.title,
            memo: model.memo,
            startDate: model.startDate,
            endDate: model.endDate,
            completed: model.completed,
            isChallenge: model.isChallenge,
            percentage: model.percentage,
            images: images,
            iscompleted: model.isCompleted,
            repetition: model.repetition,
            reminderTime: model.reminderTime
        )
    }

    
    func removeNotificationsForTodoId(id: UUID) {
        guard let todo = fetchTodoById(id: id), let identifiers = todo.notificationIdentifiers else {
            print("No notifications to remove for Todo ID \(id)")
            return
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        todo.notificationIdentifiers = []
        saveContext()
    }

    
    // Delete
    func deleteTodoById(id: UUID) {
        removeNotificationsForTodoId(id: id)
        guard let todoToDelete = fetchTodoById(id: id) else {
            print("Todo not found")
            return
        }
        
        context.perform {
            self.context.delete(todoToDelete)
            self.saveContext()
        }
        
    }
    
    func deleteAllTodos() {
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoModel.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.context.execute(deleteRequest)
                self.saveContext()
            } catch {
                print("Failed to delete all todos: \(error)")
            }
        }
    }
}
