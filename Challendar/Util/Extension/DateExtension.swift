import Foundation

extension Date {
    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        
        let selfComponents = calendar.dateComponents([.year, .month], from: self)
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        return selfComponents.year == dateComponents.year && selfComponents.month == dateComponents.month
    }
    
    func daysBetween(_ otherDate: Date) -> Int {
        let secondsInDay: TimeInterval = 86400
        let timeInterval = self.timeIntervalSince(otherDate)
        let days = Int(timeInterval / secondsInDay)
        return abs(days)
    }
    
}
