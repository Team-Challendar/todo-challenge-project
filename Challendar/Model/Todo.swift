import UIKit

//enum RepetitionCycle : Hashable {
//    case daily
//    case weekly([Int])              // Array of weekdays, where 1 = Sunday, 7 = Saturday
//    case monthly([Int])             // Array of days of the month, where 1 = 1st, 31 = 31st
//    case yearly([DateComponents])   // Array of date components representing specific days of the year
//    case none
//}
let now = Date()
let yesterday = now - 86400
let tomorrow = now + 86400


class Todo : Hashable{
    public var id : UUID?
    public var title: String
    public var memo: String?
    public var startDate: Date?
    public var endDate: Date? {
        didSet{
            initializeCompletedDictionary()
//            completed = [Date: Bool](repeating: false, count: ((endDate?.daysBetween(startDate) ?? 0) + 1))
        }
    }
    public var completed: [Date: Bool] = [:]{
        didSet{
            updatePercentage()
        }
    }
    public var isChallenge: Bool = false
    public var percentage: Double = 0
    public var images: [UIImage]?
    public var iscompleted = false
    public var repetition: [Int] = [] {
        didSet{
            initializeCompletedDictionary()
        }
    } // 0~6 index로 요일과 비교        (월,수,금) 반복 날짜 입력받아서 다시 Text로 반환하는 함수
    public var reminderTime: Date?  // 추후에 시간만 추출하는 함수 구현
    
    init(id: UUID? = nil, title: String = "", memo: String? = nil, startDate: Date? = nil, endDate: Date? = nil, completed: [Date: Bool] = [:], isChallenge: Bool = false, percentage: Double = 0, images: [UIImage]? = nil, iscompleted: Bool = false, repetition: [Int] = [0,1,2,3,4,5,6], reminderTime: Date? = nil) {
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
    }
    
    private func initializeCompletedDictionary() {
        print(repetition)
        completed = [:]
        guard let startDate = startDate, let endDate = endDate else { return }
        let days = endDate.daysBetween(startDate)+1
        for day in 0...days {
            let date = startDate.addingDays(day)!

            if repetition.contains(date.weekdayIndex) {
                completed[date] = false
            }
        }
        updatePercentage()
    }
    
    private func updatePercentage() {
        let completedCount = completed.filter { $0.value == true }.count
        percentage = Double(completedCount) / Double(completed.count)
    }
    
    func todayCompleted(date: Date = Date()) -> Bool? {
        return completed[date.startOfDay()!]
    }
    
    func toggleTodaysCompletedState() {
        let today = Date()
        if let _ = completed[today.startOfDay()!] {
            completed[today.startOfDay()!]?.toggle()
        }
//        if let currentStatus = completed[today] {
//            completed[today] = !currentStatus
//        }
    }
    
    func toggleDatesCompletedState(date: Date) {
        if let _ = completed[date.startOfDay()!] {
            completed[date.startOfDay()!]?.toggle()
        }
//        if let currentStatus = completed[date] {
//            completed[date] = !currentStatus
//        }
    }
    
    func setRepetitonDate(daysOfWeek: [String]) {
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.dateFormat = "EEEE"    // 요일 형식
        
        repetition = daysOfWeek.compactMap { daysOfWeek in
            dayFormatter.date(from: daysOfWeek)?.weekdayIndex
        }
    }
    
    func setReminderTime(hour: Int, minute: Int) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let calendar = Calendar.current
        reminderTime = calendar.date(from: dateComponents)
    }
    
    func getReminderTime() -> Date? {
        return reminderTime
    }
    

    
    func getPercentageToToday() -> Double {
        let today = Date()
        let completedUntilToday = completed.filter { $0.key <= today }
        let completedCount = completedUntilToday.values.filter { $0 == true }.count
        let percentage = Double(completedCount) / Double(completedUntilToday.count)
        return percentage
    }
    //MARK: - 오늘기준으로 Todo의 completed 값 리턴, 매개변수 추가 안할시에는 자동으로 오늘 기준
//    func todayCompleted(date: Date = Date()) -> Bool?{
//        if let startDate = startDate, let endDate = endDate{
//            if (date.isBetween(startDate, endDate)){
//                return self.completed[date.daysBetween(startDate)]
//            }else{
//                return nil
//            }
//        }
//        return nil
//    }
    
    //MARK: - 오늘기준으로 Todo의 completed 배열을 toggle
//    func toggleTodaysCompletedState(){
//        if let startDate = startDate, let endDate = endDate{
//            if (Date.isTodayBetween(startDate, endDate)){
//                let today = Date()
//                self.completed[today.daysBetween(startDate)].toggle()
//            }
//        }
//    }
    //MARK: - 주어진 date기준으로 Todo의 completed 배열을 toggle
//    func toggleDatesCompletedState(date: Date){
//        if let startDate = startDate, let endDate = endDate{
//            if (date.isBetween(startDate, endDate)){
//                self.completed[date.daysBetween(startDate)].toggle()
//            }
//        }
//    }
    //MARK: - 오늘까지의 달성율
//    func getPercentageToToday() -> Double{
//        if let startDate = startDate, let endDate = endDate {
//            if Date().isBetween(startDate, endDate) {
//                let count = Date().daysBetween(startDate)
//                let completedUntilToday = completed[0...count]
//                let percentage = Double(completedUntilToday.filter{$0 == true}.count) / Double( completedUntilToday.count)
//                return percentage
//            }
//        }
//            return 0
//    }
    //MARK: - Hashable Protocol 용
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
    
    // Equatable 프로토콜을 준수하도록 구현
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.memo == rhs.memo && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.completed == rhs.completed && lhs.isChallenge == rhs.isChallenge && lhs.percentage == rhs.percentage && lhs.images == rhs.images && lhs.iscompleted == rhs.iscompleted && lhs.repetition == rhs.repetition && lhs.reminderTime == rhs.reminderTime
    }
}


