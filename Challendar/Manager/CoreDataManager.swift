import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Challendar")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CRUD Operations
    
    // Create
    func createTodo(newTodo: Todo) {
        let todo = TodoModel(context: context)
        todo.id = UUID()
        todo.title = newTodo.title
        todo.memo = newTodo.memo
        todo.startDate = newTodo.startDate
        todo.endDate = newTodo.endDate
        todo.completed = newTodo.completed
        
        todo.isChallenge = newTodo.isChallenge
        todo.percentage = newTodo.percentage
        
        if let imagesArray = newTodo.images {
            let imageData = imagesArray.map { $0.pngData() }
            todo.images = try? JSONEncoder().encode(imageData)
        }
        
        saveContext()
    }
    
    // Save context
      func saveContext() {
          if context.hasChanges {
              do {
                  try context.save()
                  NotificationCenter.default.post(name: NSNotification.Name("CoreDataChanged"), object: nil, userInfo: nil)
              } catch {
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }
    
    // Read
    func fetchTodos() -> [Todo] {
        let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        
        // 날짜 내림차순 정렬 요청
        let dateOrder = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [dateOrder]
        
        do {
            let todoModels = try context.fetch(fetchRequest)
            return todoModels.map { model in
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
                    images: images
                )
            }
        } catch {
            print("Failed to fetch todos: \(error)")
            return []
        }
    }
    
    private func fetchTodoById(id: UUID) -> TodoModel? {
        let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let todos = try context.fetch(fetchRequest)
            return todos.first
        } catch {
            print("Failed to fetch todo by id: \(error)")
            return nil
        }
    }
    
    // Update
    func updateTodoById(id: UUID, newTitle: String? = nil, newMemo: String? = nil, newStartDate: Date? = nil, newEndDate: Date? = nil, newCompleted: [Bool]? = nil, newIsChallenge: Bool? = nil, newPercentage: Double? = nil, newImages: [UIImage]? = nil) {
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
            todoToUpdate.percentage = Double(newCompleted.filter{$0 == true}.count) / Double( newCompleted.count)
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
        
        saveContext()
    }
    
    // Delete
    func deleteTodoById(id: UUID) {
        guard let todoToDelete = fetchTodoById(id: id) else {
            print("Todo not found")
            return
        }
        
        context.delete(todoToDelete)
        saveContext()
    }
    
    func deleteAllTodos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete all todos: \(error)")
        }
    }
}
