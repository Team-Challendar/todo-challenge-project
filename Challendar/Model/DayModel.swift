import UIKit

// 
class Day {
    var date : Date
    var listCount : Int
    var completedListCount : Int
    var percentage : Double
    var toDo: [Todo]
    
    
    init(date: Date, listCount: Int, completedListCount: Int, percentage: Double, todo: [Todo]) {
        self.date = date
        self.listCount = listCount
        self.completedListCount = completedListCount
        self.percentage = percentage
        self.toDo = todo
    }
}
