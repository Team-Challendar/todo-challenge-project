//
//  ButtonIntent.swift
//  Challendar
//
//  Created by Sam.Lee on 6/25/24.
//

import Foundation
import AppIntents
import CoreData
import WidgetKit

struct ButtonIntent: AppIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Update Todo"
    
    @Parameter(title: "Todo ID")
    var todoID: String
    
    @Parameter(title: "Todo Type")
    var todoType: TodoItemType
    
    init(todoID: String, todoType: TodoItemType) {
        self.todoID = todoID
        self.todoType = todoType
    }
    
    func perform() async throws -> some IntentResult {
        // Perform the action
        guard let todoUUID = UUID(uuidString: todoID),
            let todo = CoreDataManager.shared.fetchTodos().first(where: {
                $0.id?.uuidString == todoID
            }) else {
                return .result()
            }
        if todoType == .todo {
            todo.iscompleted.toggle()
            CoreDataManager.shared.updateTodoById(id: todo.id!, newIsCompleted: todo.iscompleted)
        } else {
            todo.toggleTodaysCompletedState()
            CoreDataManager.shared.updateTodoById(id: todo.id!, newCompleted: todo.completed)
        }
        
        // Delay for 1 second
        try await Task.sleep(for: .seconds(1))
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadTimelines(ofKind: "ChallendarWidget")
        }
        // Reload widget timeline
        
        return .result()
    }
}
