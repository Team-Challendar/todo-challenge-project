//
//  TodoWidget.swift
//  Challendar
//
//  Created by 채나연 on 6/20/24.
//


//TodoWidget을 설정하고 Core Data에서 데이터를 가져와 위젯에 표시하는 기능 제공

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
        do {
            let todos = CoreDataManager.shared.fetchTodos()
            for todo in todos {
                let entry = SimpleEntry(date: Date(), title: todo.title, isCompleted: todo.iscompleted)
                entries.append(entry)
            }
        } catch {
            print("Error fetching todos: \(error)")
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
            Text(entry.isCompleted ? "Completed" : "Not Completed")
        }
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TodoListIntent.self, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo Widget")
        .description("Displays a list of todos.")
    }
}

