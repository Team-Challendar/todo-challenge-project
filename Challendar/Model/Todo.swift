import UIKit

enum RepetitionCycle : Hashable {
    case daily
    case weekly([Int]) // Array of weekdays, where 1 = Sunday, 7 = Saturday
    case monthly([Int]) // Array of days of the month, where 1 = 1st, 31 = 31st
    case yearly([DateComponents]) // Array of date components representing specific days of the year
    case none
}

class Todo: Hashable {
    public var id: UUID?
    public var title: String
    public var memo: String?
    public var startDate: Date?
    public var endDate: Date? {
        didSet {
            initializeCompletedDictionary()
        }
    }
    public var completed: [Date: Bool] = [:] {
        didSet {
            updatePercentage()
        }
    }
    public var isChallenge: Bool = false
    public var percentage: Double = 0
    public var images: [UIImage]?
    public var iscompleted = false
    public var repetition: RepetitionCycle = .none // New property for repetition
    public var reminderTime: DateComponents? // Single reminder time for all applicable dates

    init(id: UUID? = nil, title: String = "", memo: String? = nil, startDate: Date? = nil, endDate: Date? = nil, completed: [Date: Bool] = [:], isChallenge: Bool = false, percentage: Double = 0, images: [UIImage]? = nil, iscompleted: Bool = false, repetition: RepetitionCycle = .none, reminderTime: DateComponents? = nil) {
        self.id = id
        self.title = title
        self.memo = memo
        self.startDate = startDate
        self.endDate = endDate
        self.completed = completed
        self.isChallenge = isChallenge
        self.percentage = percentage
        self.images = images
        self.iscompleted = iscompleted
        self.repetition = repetition
        self.reminderTime = reminderTime
        initializeCompletedDictionary()
    }

    private func initializeCompletedDictionary() {
        guard let startDate = startDate, let endDate = endDate else { return }

        let calendar = Calendar.current
        switch repetition {
        case .daily:
            var currentDate = startDate
            while currentDate <= endDate {
                completed[currentDate] = false
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        case .weekly(let weekdays):
            var currentDate = startDate
            while currentDate <= endDate {
                let weekday = calendar.component(.weekday, from: currentDate)
                if weekdays.contains(weekday) {
                    completed[currentDate] = false
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        case .monthly(let days):
            var currentDate = startDate
            while currentDate <= endDate {
                let day = calendar.component(.day, from: currentDate)
                if days.contains(day) {
                    completed[currentDate] = false
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        case .yearly(let dates):
            var currentDate = startDate
            while currentDate <= endDate {
                let components = calendar.dateComponents([.month, .day], from: currentDate)
                if dates.contains(where: { $0.month == components.month && $0.day == components.day }) {
                    completed[currentDate] = false
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        case .none:
            completed[startDate] = false
        }
        updatePercentage()
    }

    private func updatePercentage() {
        let completedCount = completed.values.filter { $0 == true }.count
        percentage = Double(completedCount) / Double(completed.count)
    }

    func todayCompleted(date: Date = Date()) -> Bool? {
        return completed[date]
    }

    func toggleTodaysCompletedState() {
        let today = Date()
        if let currentStatus = completed[today] {
            completed[today] = !currentStatus
        }
    }

    func toggleDatesCompletedState(date: Date) {
        if let currentStatus = completed[date] {
            completed[date] = !currentStatus
        }
    }

    func setReminderTime(hour: Int, minute: Int) {
        reminderTime = DateComponents(hour: hour, minute: minute)
    }

    func getReminderTime() -> DateComponents? {
        return reminderTime
    }

    func getPercentageToToday() -> Double {
        let today = Date()
        let completedUntilToday = completed.filter { $0.key <= today }
        let completedCount = completedUntilToday.values.filter { $0 == true }.count
        let percentage = Double(completedCount) / Double(completedUntilToday.count)
        return percentage
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(memo)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(completed)
        hasher.combine(isChallenge)
        hasher.combine(percentage)
        hasher.combine(images)
        hasher.combine(iscompleted)
        hasher.combine(repetition)
        hasher.combine(reminderTime)
    }

    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.memo == rhs.memo && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.completed == rhs.completed && lhs.isChallenge == rhs.isChallenge && lhs.percentage == rhs.percentage && lhs.images == rhs.images && lhs.iscompleted == rhs.iscompleted && lhs.repetition == rhs.repetition && lhs.reminderTime == rhs.reminderTime
    }
}
