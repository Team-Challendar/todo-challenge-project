//
//  Provider.swift
//  Challendar
//
//  Created by 채나연 on 6/20/24.
//

//import WidgetKit
//import SwiftUI
//import CoreData
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let todos: [Todo]
//}
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), todos: [])
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
//        let entry = SimpleEntry(date: Date(), todos: fetchTodos())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
//        let entries = [
//            SimpleEntry(date: Date(), todos: fetchTodos())
//        ]
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//
//    private func fetchTodos() -> [Todo] {
//        // Core Data에서 데이터를 가져오는 로직
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
//
//        do {
//            let todoModels = try context.fetch(fetchRequest)
//            let todos = todoModels.map { todoModel -> Todo in
//                return Todo(
//                    id: todoModel.id,
//                    title: todoModel.title ?? "",
//                    isCompleted: todoModel.isCompleted
//                )
//            }
//            return todos
//        } catch {
//            print("Failed to fetch todos: \(error)")
//            return []
//        }
//    }
//}
//
//let persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "Challendar")
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//        if let error as NSError? {
//            fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//    })
//    return container
//}()
//
