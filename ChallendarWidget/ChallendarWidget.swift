//
//  ChallendarWidget.swift
//  ChallendarWidget
//
//  Created by Sam.Lee on 6/25/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todo: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let selectedTodo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.id == configuration.selectedTodo!.id
        })
        return SimpleEntry(date: Date(), todo: selectedTodo)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let selectedTodo = CoreDataManager.shared.fetchTodos().first(where: {
                $0.id == configuration.selectedTodo!.id
            })
            let entry = SimpleEntry(date: entryDate, todo: selectedTodo)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func fetchDetailedTodoById(id: UUID) -> Todo? {
        let todo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.id == id
        })
        return todo
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todo: Todo?
}

struct ChallendarWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            if let todo = entry.todo {
                Text(todo.title)
                    .font(.headline)
                if let startDate = todo.startDate {
                    Text("Start Date: \(startDate, formatter: dateFormatter)")
                        .font(.caption)
                }
                if let endDate = todo.endDate {
                    Text("End Date: \(endDate, formatter: dateFormatter)")
                        .font(.caption)
                }
                Button(intent: ButtonIntent(todoID: todo.id!.uuidString)) {
                    Image(uiImage: todo.todayCompleted()! ? UIImage(named: "done0")! : UIImage(named: "done2")!)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .tint(.clear)
                .background(.clear)
            } else {
                Text("No Todo Selected")
                    .font(.headline)
            }
        }
        .padding()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct ChallendarWidget: Widget {
    let kind: String = "ChallendarWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ChallendarWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Todo List Widget")
        .description("Displays a selected todo item.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}
