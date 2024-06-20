import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let isCompleted: Bool
}

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = TodoListIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Sample Task", isCompleted: false)
    }

    func getSnapshot(for configuration: TodoListIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Sample Task", isCompleted: false)
        completion(entry)
    }

    func getTimeline(for configuration: TodoListIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Fetch todos from Core Data
        let todos = CoreDataManager.shared.fetchTodos()

        if let randomTodo = todos.randomElement() {
            let entry = SimpleEntry(date: Date(), title: randomTodo.title, isCompleted: randomTodo.iscompleted)
            entries.append(entry)
        } else {
            // If no todos are found, add a placeholder entry
            let entry = SimpleEntry(date: Date(), title: "No Tasks", isCompleted: false)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TodoWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.title)
                .font(.headline)
            Text(entry.isCompleted ? "Completed" : "Not Completed")
                .font(.subheadline)
                .foregroundColor(entry.isCompleted ? .green : .red)
        }
        .padding()
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TodoListIntent.self, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo Widget")
        .description("Displays a random todo.")
    }
}
