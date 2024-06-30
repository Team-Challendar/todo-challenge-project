import WidgetKit
import AppIntents
import CoreData

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "표시 내용", default: TodoItemType.plan)
    var todoType: TodoItemType?
}

enum TodoItemType: String, AppEntity {
    case todo = "할 일"
    case plan = "계획"
    case challenge = "챌린지"

    // Required for AppEntity
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Todo Type")
    }

    // Required for AppEntity
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: self.rawValue))
    }

    static var allTodoItemTypes: [TodoItemType] = [.todo, .plan, .challenge]

    static var defaultQuery = TodoItemTypeQuery()
}

struct TodoItemTypeQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [TodoItemType] {
        return TodoItemType.allTodoItemTypes
    }
    
    func entities(matching string: String) async throws -> [TodoItemType] {
        return TodoItemType.allTodoItemTypes.filter {
            $0.rawValue.localizedCaseInsensitiveContains(string)
        }
    }

    func suggestedEntities() async throws -> [TodoItemType] {
        return TodoItemType.allTodoItemTypes
    }
}

