import Foundation

extension Date {
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        
        return localDate
    }
    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    func dateToString () -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년MM월dd일 HH:mm"
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone.current
        return dateformatter.string(from: self)
    }
    static func stringToDate(string : String) -> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년MM월dd일 HH:mm"
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone.current
        return dateformatter.date(from: string)!
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
        let calendar = Calendar.current
        let startOfDay1 = self.startOfDay()
        let startOfDay2 = otherDate.startOfDay()
        
        let components = calendar.dateComponents([.day], from: startOfDay1, to: startOfDay2)
        return abs(components.day ?? 0)
    }
    
    func addingDays(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
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
