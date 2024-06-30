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
        SimpleEntry(date: Date(), todo: nil, type: TodoItemType.todo, totalCount: 0, completedList: 0)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(date: Date(), todo: nil, type: configuration.todoType ?? .todo, totalCount: 0, completedList: 0)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // fetchTodos를 호출하여 최신 데이터를 가져옵니다.
        let todoList = fetchTodos(for: configuration.todoType)
        let totalCount = todoList.count
        let completedCount = todoList.filter { $0.todayCompleted() ?? false }.count
        
        let entry = SimpleEntry(date: currentDate, todo: todoList, type: configuration.todoType ?? .todo, totalCount: totalCount, completedList: completedCount)
        entries.append(entry)
        
        // .never 정책을 사용하여 명시적으로 reloadTimeline 호출할 때까지 업데이트하지 않음
        return Timeline(entries: entries, policy: .never)
    }
    
    private func fetchTodos(for type: TodoItemType?) -> [Todo] {
        var todoList: [Todo] = CoreDataManager.shared.fetchTodos()
        
        switch type {
        case .todo:
            todoList = todoList.filter { $0.endDate == nil }
        case .plan:
            todoList = todoList.filter {
                if let endDate = $0.endDate, let startDate = $0.startDate {
                    return !$0.isChallenge && $0.completed[Date().startOfDay()!] != nil 
                }
                return false
            }
        case .challenge:
            todoList = todoList.filter {
                if let endDate = $0.endDate, let startDate = $0.startDate {
                    return $0.isChallenge && $0.completed[Date().startOfDay()!] != nil
                }
                return false
            }
        default:
            todoList = []
        }
        
        return todoList
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
    let todo: [Todo]?
    let type : TodoItemType
    let totalCount : Int
    let completedList: Int
}

struct ChallendarWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWidgetView(todos: entry.todo, type: entry.type, totalCount: entry.totalCount, completedCount: entry.completedList)
        case .systemMedium:
            MediumWidgetView(todos: entry.todo, type: entry.type, totalCount: entry.totalCount, completedCount: entry.completedList)
        case .systemLarge:
            LargeWidgetView(todos: entry.todo, type: entry.type, totalCount: entry.totalCount, completedCount: entry.completedList)
        default:
            Text("Unsupported size")
        }
    }
}

struct SmallWidgetView: View {
    @State var todos: [Todo]?
    @State var type: TodoItemType?
    @State var totalCount: Int?
    @State var completedCount: Int?
    
    private func colorsAndTitle(for type: TodoItemType?) -> (UIColor, UIColor, String) {
        switch type {
        case .todo:
            return (.alertTomato, .alertTomato300, "할 일")
        case .plan:
            return (.challendarBlue600, .challendarBlue300, "남은 계획")
        case .challenge:
            return (.challendarGreen200, .challendarGreen100, "챌린지")
        case .none:
            return (.alertTomato, .alertTomato300, "챌린지")
        }
    }
    
    var body: some View {
        let (mainUIColor, subColor, title) = colorsAndTitle(for: type)
        VStack {
            Spacer(minLength: 8)
            HStack(alignment: .top) {
                Spacer(minLength: 16)
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center) {
                        Text(title)
                            .font(Font.custom("SUITE-Bold", size: 16))
                            .foregroundStyle(Color(mainUIColor))
                            .lineLimit(1)
                        Spacer(minLength: 10)
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("\(completedCount ?? 0)")
                                .font(Font.custom("Roboto-BoldItalic", size: 24))
                                .foregroundStyle(Color(subColor))
                            Text(" / \(totalCount ?? 0)")
                                .font(Font.custom("Roboto-BoldItalic", size: 20))
                                .foregroundStyle(Color(uiColor: .secondary600))
                        }
                    }
                    VStack(alignment: .leading) {
                        if let todos = todos {
                            ForEach(Array(todos.prefix(3).enumerated()), id: \.element.id) { index, todo in
                                HStack(alignment: .top, spacing: 10) {
                                    Button(intent: ButtonIntent(todoID: todo.id!.uuidString, todoType: type!)) {
                                        if type == .todo {
                                            Image(uiImage: (todo.iscompleted ? UIImage(named: "done1")! : UIImage(named: "done0"))!)
                                                .renderingMode(.template)
                                                .foregroundColor(todo.iscompleted ? Color(uiColor: mainUIColor) : Color(uiColor: .secondary800))
                                        } else {
                                            Image(uiImage: (todo.todayCompleted()! ? UIImage(named: "done1")! : UIImage(named: "done0"))!)
                                                .renderingMode(.template)
                                                .foregroundColor(todo.todayCompleted()! ? Color(uiColor: mainUIColor) : Color(uiColor: .secondary800))
                                        }
                                    }
                                    .frame(width: 24, height: 24)
                                    .background(.clear)
                                    .tint(.clear)
                                    .contentTransition(.interpolate)
                                    VStack(alignment: .leading) {
                                        Text(todo.title)
                                            .font(Font.custom("Pretendard-Regular", size: 13))
                                            .foregroundStyle(.secondary050)
                                            .frame(height: 21.5)
                                            .invalidatableContent()
                                        if index != todos.prefix(3).count - 1 {
                                            DashedLine()
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [1]))
                                                .foregroundColor(Color(uiColor: .secondary800))
                                                .frame(height: 1)
                                        } else {
                                            Spacer()
                                        }
                                    }
                                }
                                Spacer(minLength: 8)
                            }
                        } else {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("리스트가 없어요")
                                    .font(Font.custom("Pretendard-Regular", size: 13))
                                    .foregroundStyle(.secondary050)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
                Spacer(minLength: 16)
            }
        }
        .widgetBackground(Color(UIColor.secondary800))
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct MediumWidgetView: View {
    let todos: [Todo]?
    let type : TodoItemType?
    var totalCount : Int?
    var completedCount: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("할 일 목록")
                .font(.headline)
            if let todos = todos {
                ForEach(todos.prefix(3), id: \.id) { todo in
                    Text(todo.title)
                        .font(.subheadline)
                }
            } else {
                Text("No Todos Available")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

struct LargeWidgetView: View {
    let todos: [Todo]?
    let type : TodoItemType?
    var totalCount : Int?
    var completedCount : Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("할 일 목록")
                .font(.headline)
            if let todos = todos {
                ForEach(todos, id: \.id) { todo in
                    Text(todo.title)
                        .font(.subheadline)
                }
            } else {
                Text("No Todos Available")
                    .font(.subheadline)
            }
        }
        
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
                .containerBackground(.secondary850, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium,.systemLarge])
        .configurationDisplayName("챌린더 위젯")
        .description("화면을 선택해라")
        .contentMarginsDisabled()
    }
}


extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
