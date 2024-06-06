import Foundation

extension Date {
    static func currentTimeZone (date: Date) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년MM월dd일"
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone.current
        return dateformatter.string(from: date)
    }
    
    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        
        let selfComponents = calendar.dateComponents([.year, .month], from: self)
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        return selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month
    }
    
    func isBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        return self >= startDate && self <= endDate
    }
    
    static func isTodayBetween(_ startDate: Date, _ endDate: Date) -> Bool {
        let today = Date()
        return today.isBetween(startDate, endDate)
    }
    
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        return selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month && selfComponents.day == dateComponents.day
    }
    
    func daysBetween(_ otherDate: Date) -> Int {
        let secondsInDay: TimeInterval = 86400
        let timeInterval = self.timeIntervalSince(otherDate)
        let days = Int(timeInterval / secondsInDay)
        return abs(days)
    }
    
    static func today() -> Date {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 23
        components.minute = 59
        if let targetDate = calendar.date(from: components) {
            return targetDate
        } else {
            return Date()
        }
    }
    
    static func week() -> Date{
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: now)
        if let nextSunday = calendar.date(byAdding: .day, value: 7, to: now) {
            var sundayComponents = calendar.dateComponents([.year, .month, .day], from: nextSunday)
            sundayComponents.hour = 23
            sundayComponents.minute = 59
            if let targetDate = calendar.date(from: sundayComponents) {
                return targetDate
            } else {
                return Date()
            }
        } else {
           return Date()
        }
    }
    
    static func tomorrow() -> Date{
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: now)
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: now) {
            var tomorrowComponents = calendar.dateComponents([.year, .month, .day], from: nextDay)
            tomorrowComponents.hour = 23
            tomorrowComponents.minute = 59
            if let targetDate = calendar.date(from: tomorrowComponents) {
                return targetDate
            } else {
                return Date()
            }
        } else {
           return Date()
        }
    }
}
