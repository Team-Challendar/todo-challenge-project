//
//  IntentHandler.swift
//  Challendar
//
//  Created by 채나연 on 6/19/24.
//

import Intents
import Intents
import CoreData

class IntentHandler: INExtension, TodoListIntentHandling {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func provideTodosOptionsCollection(for intent: TodoListIntent, with completion: @escaping (INObjectCollection<Todo>?, Error?) -> Void) {
        let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        do {
            let todos = try context.fetch(fetchRequest)
            let todoItems = todos.map { todo in
                return Todo(identifier: todo.id?.uuidString, display: todo.title)
            }
            let collection = INObjectCollection(items: todoItems)
            completion(collection, nil)
        } catch {
            completion(nil, error)
        }
    }

    func resolveTitle(for intent: TodoListIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let title = intent.title, !title.isEmpty {
            completion(.success(with: title))
        } else {
            completion(.needsValue())
        }
    }

    func resolveIsCompleted(for intent: TodoListIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        if let isCompleted = intent.isCompleted {
            completion(.success(with: isCompleted.boolValue))
        } else {
            completion(.needsValue())
        }
    }
}


