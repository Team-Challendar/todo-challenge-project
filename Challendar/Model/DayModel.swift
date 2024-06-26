import UIKit

// 달력에서 사용하는 모델
class Day : Hashable{
    var date : Date
    var listCount : Int
    var completedListCount : Int
    var percentage : Double
    var toDo: [Todo]
    
    // 해당하는 ID 혹은
    init(date: Date, listCount: Int, completedListCount: Int, percentage: Double, todo: [Todo]) {
        self.date = date
        self.listCount = listCount
        self.completedListCount = completedListCount
        self.percentage = percentage
        self.toDo = todo
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(listCount)
        hasher.combine(completedListCount)
        hasher.combine(percentage)
        hasher.combine(toDo)
    }
    
    // Implementing the == operator for Hashable
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date && lhs.listCount == rhs.listCount && lhs.completedListCount == rhs.completedListCount && lhs.percentage == rhs.percentage && lhs.toDo == rhs.toDo
    }
}

extension Day {
    // 주어진 날짜 +-1 달까지 포함해서 [Day] 리턴
    static func generateDaysForMonth(date: Date, todos: [Todo]) -> [Day] {
        var days: [Day] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 지정된 날짜의 연도와 월 설정
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else {
            return days
        }
        
        // 3개월 동안의 데이터를 생성 (이전 달, 현재 달, 다음 달)
        for monthOffset in -1...1 {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month + monthOffset
            dateComponents.day = 1
            
            guard let startOfMonth = calendar.date(from: dateComponents),
                  let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
                continue
            }
            
            let numberOfDaysInMonth = range.count
            
            // 지정된 월의 모든 날에 대해 Day 객체 생성
            for dayOffset in 0..<numberOfDaysInMonth {
                guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) else { continue }
                
                // 현재 날짜에 해당하는 Todo 필터링
                let dailyTodos = todos.filter { todo in
                    guard let startDate = todo.startDate, let endDate = todo.endDate else { return false }
                    return currentDate.isBetween(startDate, endDate)
                }
                
                let listCount = dailyTodos.count
                
//                let completedListCount = dailyTodos.filter {
//                    $0.completed[currentDate.daysBetween($0.startDate!)] == true
//                }.count
//                let percentage = listCount > 0 ? Double(completedListCount) / Double(listCount) * 100.0 : 0.0
//                
//                let day = Day(date: currentDate, listCount: listCount, completedListCount: completedListCount, percentage: percentage, todo: dailyTodos)
//                days.append(day)
            }
        }
        
        return days
    }

    
}
