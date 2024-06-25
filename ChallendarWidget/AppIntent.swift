import WidgetKit
import AppIntents
import CoreData

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Select Todo")
    var selectedTodo: TodoItemShort?
}

struct TodoItemShort: AppEntity {
    var id: UUID
    var title: String

    // Required for AppEntity
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Todo")
    }

    // Required for AppEntity
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    // Initializer
    init(from todo: Todo) {
        self.id = todo.id ?? UUID()
        self.title = todo.title
    }

    static var allTodoItem: [TodoItemShort] = {
        return CoreDataManager.shared.fetchTodos()
            .filter{
                if let endDate = $0.endDate, let startDate = $0.startDate {
                    return endDate > Date() && startDate < Date()
                }
                return false
            }
            .map { TodoItemShort(from: $0) }
            .sorted(by: { $0.title < $1.title })
    }()
}

extension TodoItemShort {
    typealias ID = UUID
    static var defaultQuery = TodoItemShortQuery()
}

struct TodoItemShortQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [TodoItemShort] {
        return TodoItemShort.allTodoItem.filter {
            $0.title.localizedCaseInsensitiveContains(string)
        }
    }

    func entities(for identifiers: [UUID]) async throws -> [TodoItemShort] {
        return TodoItemShort.allTodoItem.filter {
            identifiers.contains($0.id)
        }
    }

    func suggestedEntities() async throws -> [TodoItemShort] {
        return TodoItemShort.allTodoItem
    }
}
