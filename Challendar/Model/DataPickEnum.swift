import UIKit


enum DateRange: String , CaseIterable {
    case today = "오늘까지"
    case tomorrow = "내일까지"
    case week = "7일이내"
    case manual = "기간 직접 입력"

    var date: Date? {
        switch self {
        case .today:
            return Date.today()
        case .tomorrow:
            return Date.tomorrow()
        case . week:
            return Date.week()
        case .manual:
            return nil
        }
    }
    
}
