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

    init(todoID: String) {
        self.todoID = todoID
    }
    
    func perform() async throws -> some IntentResult {
        guard let uuid = UUID(uuidString: todoID) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UUID string"])
        }
        guard let selectedTodo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.id == UUID(uuidString: todoID)
        }) else { return .result()}
        selectedTodo.toggleTodaysCompletedState()
        CoreDataManager.shared.updateTodoById(id: UUID(uuidString: todoID)!, newCompleted: selectedTodo.completed)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
