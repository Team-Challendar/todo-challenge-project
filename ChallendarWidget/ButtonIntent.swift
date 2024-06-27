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
    init() {
        self.todoID = ""
    }
    
    static var title: LocalizedStringResource = "Update Todo"
    
    @Parameter(title: "Todo ID")
    var todoID: String // Using String instead of UUID

    @Parameter(title: "Todo Type")
    var todoType: TodoItemType
    
    init(todoID: String, todoType: TodoItemType) {
        self.todoID = todoID
        self.todoType = todoType
    }
    
    func perform() async throws -> some IntentResult {
        guard let todo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.id?.uuidString == todoID
        }) else {
            return .result()
        }
        if todoType == .todo {
            todo.iscompleted.toggle()
            CoreDataManager.shared.updateTodoById(id: todo.id!, newIsCompleted: todo.iscompleted)
        }else{
            todo.toggleTodaysCompletedState()
            CoreDataManager.shared.updateTodoById(id: todo.id!, newCompleted: todo.completed)
        }
        return .result()
    }
}
