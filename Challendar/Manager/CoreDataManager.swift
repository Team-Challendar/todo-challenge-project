import UIKit
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Challendar")
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
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    // Create
    func createTodo(newTodo: Todo) -> TodoModel? {
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
        return todo
    }
    
    // Read
    func fetchTodos() -> [TodoModel]? {
        let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Failed to fetch todos: \(error)")
            return nil
        }
    }
    
    func fetchTodoById(id: UUID) -> TodoModel? {
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
}
