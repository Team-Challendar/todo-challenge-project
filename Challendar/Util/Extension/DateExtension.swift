import Foundation

extension Date {
    func startOfDay() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }
    
    func endOfDay() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }
    func nextMonth() -> Date? {
           var dateComponents = DateComponents()
           dateComponents.month = 1
           
           let calendar = Calendar.current
           return calendar.date(byAdding: dateComponents, to: self)
       }
    func prevMonth() -> Date? {
           var dateComponents = DateComponents()
           dateComponents.month = -1
           
           let calendar = Calendar.current
           return calendar.date(byAdding: dateComponents, to: self)
       }
    func formatDateToDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "d" // Day of the month
        return dateFormatter.string(from: self)
    }
    
    
    func formatDateWeekdayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.locale = Locale(identifier: "ko_KR") // Set the locale to Korean
        dateFormatter.dateFormat = "EEEE" // Full weekday name and day of the month
        
        return dateFormatter.string(from: self)
    }
    
    func dateToString () -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy년MM월dd일 HH:mm"
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone.current
        return dateformatter.string(from: self)
    }
    
    func startToEndDate(date: Date) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM월dd일"
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.timeZone = TimeZone.current
        let start = dateformatter.string(from: self)
        let end = dateformatter.string(from: date)
        let string = "\(start) 부터 \(end)까지"
        return string
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
        
        let components = calendar.dateComponents([.day], from: startOfDay1!, to: startOfDay2!)
        return abs(components.day ?? 0)
    }
    
    func addingDays(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    func today() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }
    
    func sevenDaysFromNow() -> Date? {
        let calendar = Calendar.current
        if let dateInSevenDays = calendar.date(byAdding: .day, value: 7, to: self) {
            var components = calendar.dateComponents([.year, .month, .day], from: dateInSevenDays)
            components.hour = 23
            components.minute = 59
            components.second = 59
            return calendar.date(from: components)
        }
        return nil
    }
    
    func tomorrow() -> Date? {
        let calendar = Calendar.current
        if let dateTomorrow = calendar.date(byAdding: .day, value: 1, to: self) {
            var components = calendar.dateComponents([.year, .month, .day], from: dateTomorrow)
            components.hour = 23
            components.minute = 59
            components.second = 59
            return calendar.date(from: components)
        }
        return nil
    }
    
    func dayFromDate() -> Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return day
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    func indexForDate() -> Int {
        let calendar = Calendar.current
        let currentDay = self.day
        let currentMonth = self.month
        let currentYear = self.year
        
        // 전달의 일 수
        let previousMonth = currentMonth - 1 == 0 ? 12 : currentMonth - 1
        let previousYear = currentMonth - 1 == 0 ? currentYear - 1 : currentYear
        let previousDateComponents = DateComponents(year: previousYear, month: previousMonth)
        let previousDate = calendar.date(from: previousDateComponents)!
        let numberOfDaysInPreviousMonth = previousDate.numberOfDaysInMonth()
        
        // 현재 달의 시작 인덱스 (전달의 일 수)
        let currentMonthStartIndex = numberOfDaysInPreviousMonth
        
        // 주어진 날짜의 인덱스 (전달 일 수 + 현재 일)
        return currentMonthStartIndex + currentDay - 1
    }
}
