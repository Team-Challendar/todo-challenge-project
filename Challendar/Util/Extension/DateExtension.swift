import Foundation

extension Date {
    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        
        let selfComponents = calendar.dateComponents([.year, .month], from: self)
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        return selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month
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
        guard let currentWeekday = components.weekday else {
            return Date()
        }
        let daysUntilSunday = 8 - currentWeekday
        if let nextSunday = calendar.date(byAdding: .day, value: daysUntilSunday, to: now) {
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
