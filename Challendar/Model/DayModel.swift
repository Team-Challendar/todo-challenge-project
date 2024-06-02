import UIKit

class Day {
    var date : Date
    var listCount : Int
    var completedListCount : Int
    var percentage : Double
    
    init(date: Date, listCount: Int, completedListCount: Int, percentage: Double) {
        self.date = date
        self.listCount = listCount
        self.completedListCount = completedListCount
        self.percentage = percentage
    }
}
