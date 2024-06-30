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
        let completedCount = (configuration.todoType == .todo) ? (todoList.filter { $0.iscompleted }.count) : (todoList.filter { $0.todayCompleted() ?? false }.count)
        
        let entry = SimpleEntry(date: currentDate, todo: todoList, type: configuration.todoType ?? .todo, totalCount: totalCount, completedList: completedCount)
        entries.append(entry)
        
        // .never 정책을 사용하여 명시적으로 reloadTimeline 호출할 때까지 업데이트하지 않음
        return Timeline(entries: entries, policy: .never)
    }
    
    private func fetchTodos(for type: TodoItemType?) -> [Todo] {
        var todoList: [Todo] = []
        CoreDataManager.shared.context.performAndWait {
            todoList = CoreDataManager.shared.fetchTodos()
        }
        
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
        var todo: Todo?
        CoreDataManager.shared.context.performAndWait {
            todo = CoreDataManager.shared.fetchTodos().first(where: { $0.id == id })
        }
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
                        if let todos = todos, todos.count > 0 {
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
                                    .foregroundStyle(.secondary700)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
                Spacer(minLength: 16)
            }
        }
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
    @State var todos: [Todo]?
    @State var type: TodoItemType?
    @State var totalCount: Int?
    @State var completedCount: Int?
    
    private func colorsAndTitle(for type: TodoItemType?) -> (UIColor, UIColor, String, Image) {
        switch type {
        case .todo:
            return (.alertTomato, .alertTomato300, "할 일", Image(.todoLogo))
        case .plan:
            return (.challendarBlue600, .challendarBlue300, "남은 계획", Image(.scheduleLogo))
        case .challenge:
            return (.challendarGreen200, .challendarGreen100, "챌린지", Image(.challengeLogo))
        case .none:
            return (.challendarGreen200, .challendarGreen100, "챌린지", Image(.challengeLogo))
        }
    }
    
    var body: some View {
        let (mainUIColor, subColor, title, logo) = colorsAndTitle(for: type)
        HStack(alignment: .center, spacing: 24){
            VStack(alignment: .leading){
                logo
                    .resizable()
                    .frame(width: 40, height: 40)
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(completedCount ?? 0)")
                        .font(Font.custom("Roboto-BoldItalic", size: 24))
                        .foregroundStyle(Color(subColor))
                    Text(" / \(totalCount ?? 0)")
                        .font(Font.custom("Roboto-BoldItalic", size: 20))
                        .foregroundStyle(Color(uiColor: .secondary600))
                }
                Text(title)
                    .font(Font.custom("SUITE-Bold", size: 16))
                    .foregroundStyle(Color(mainUIColor))
                    .lineLimit(1)
                    .kerning(0.1)
            }
            .padding(0)
            .frame(width: 75, height: 125, alignment: .leading)
            VStack(alignment: .center, spacing: 0) {
                if let todos = todos, todos.count > 0 {
                    ForEach(Array(todos.prefix(4).enumerated()), id: \.element.id) { index, todo in
                        HStack() {
                            HStack(spacing: 0) {
                                ZStack() {
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
                                    .background(.clear)
                                    .tint(.clear)
                                    .contentTransition(.interpolate)
                                }
                                .frame(width: 24, height: 24)
                            }
                            .frame(width: 24, height: 24)
                            Text(todo.title)
                                .font(Font.custom("Pretendard", size: 13))
                                .lineSpacing(17.55)
                                .foregroundStyle(.secondary050)
                                .frame(maxWidth: .infinity, minHeight: 21.5, maxHeight: 21.5, alignment: .leading)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 35)
                        ZStack() {
                            if index != todos.prefix(4).count - 1 {
                                Image(.separator)
                            }else{
                                Spacer()
                            }
                        }
                        .frame(width: 208, height: 1)
                    }
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("리스트가 없어요")
                            .font(Font.custom("Pretendard-Regular", size: 13))
                            .foregroundStyle(.secondary700)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .padding(0)
            .frame(width: 208, alignment: .topLeading)
        }
        .padding(.leading, 16)
        .padding(.trailing, 15)
        .padding(.vertical, 6)
    }
}

struct LargeWidgetView: View {
    @State var todos: [Todo]?
    @State var type: TodoItemType?
    @State var totalCount: Int?
    @State var completedCount: Int?
    
    private func colorsAndTitle(for type: TodoItemType?) -> (UIColor, UIColor, String, Image) {
        switch type {
        case .todo:
            return (.alertTomato, .alertTomato300, "할 일", Image(.todoLogo))
        case .plan:
            return (.challendarBlue600, .challendarBlue300, "남은 계획", Image(.scheduleLogo))
        case .challenge:
            return (.challendarGreen200, .challendarGreen100, "챌린지", Image(.challengeLogo))
        case .none:
            return (.challendarGreen200, .challendarGreen100, "챌린지", Image(.challengeLogo))
        }
    }
    
    
    var body: some View {
        let (mainUIColor, subColor, title, logo) = colorsAndTitle(for: type)
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("\(completedCount ?? 0)")
                            .font(Font.custom("Roboto-BoldItalic", size: 32))
                            .foregroundStyle(Color(subColor))
                        Text(" / \(totalCount ?? 0)")
                            .font(Font.custom("Roboto-BoldItalic", size: 24))
                            .foregroundStyle(Color(uiColor: .secondary600))
                    }
                    Spacer(minLength: 12)
                    Text(title)
                        .font(Font.custom("SUITE-Bold", size: 16))
                        .foregroundStyle(Color(mainUIColor))
                        .lineLimit(1)
                        .kerning(0.1)
                }
                .padding(0)
                .frame(width: 242, height: 66, alignment: .leading)
                Spacer()
                HStack(alignment: .top) {
                    // Space Between
                    Spacer()
                    // Alternative Views and Spacers
                    VStack(alignment: .trailing){
                        logo
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            Rectangle()
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity, minHeight: 2, maxHeight: 2)
            .background(Color(mainUIColor))
            .cornerRadius(1)
            .padding(.vertical , 4)
            VStack(alignment: .center, spacing: 0) {
                if let todos = todos, todos.count > 0 {
                    ForEach(Array(todos.prefix(6).enumerated()), id: \.element.id) { index, todo in
                        HStack(alignment: .center, spacing: 10) {
                            HStack(spacing: 0) {
                                ZStack() {
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
                                    .background(.clear)
                                    .tint(.clear)
                                    .contentTransition(.interpolate)
                                }
                                .frame(width: 24, height: 24)
                            }
                            .frame(width: 24, height: 24)
                            Text(todo.title)
                                .font(Font.custom("Pretendard", size: 13))
                                .foregroundStyle(.secondary050)
                                .frame(maxWidth: .infinity, minHeight: 21.5, maxHeight: 21.5, alignment: .leading)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, minHeight: 37, maxHeight: 37)
                        HStack(spacing: 0) {
                            if index != todos.prefix(6).count - 1 {
                                Image(.separator2)
                                    .resizable()
                                    .frame(width: 272, height: 0.9)
                            }else{
                                Spacer()
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 34, bottom: 0.10, trailing: 0))
                        .frame(width: 272, height: 1)
                    }
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("리스트가 없어요")
                            .font(Font.custom("Pretendard-Regular", size: 13))
                            .foregroundStyle(.secondary700)
                        Spacer()
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .frame(minWidth: 306, maxWidth: 306, maxHeight: .infinity, alignment: .topLeading)
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
                .invalidatableContent()
        }
        .supportedFamilies([.systemSmall, .systemMedium,.systemLarge])
        .configurationDisplayName("챌린더 위젯")
        .description("위젯에 표시할 내용을 선택하세요")
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
