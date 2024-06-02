import UIKit


enum StartDate: String , CaseIterable {
    case none = "나중에 정할래요"
    case today = "오늘부터"
    case manual = "직접 입력"

    var date: Date? {
        switch self {
        case .none:
            return nil
        case .today:
            return Date()
        case .manual:
            return nil
        }
    }
    
}

enum EndDate : String, CaseIterable {
    case none = "나중에 정할래요"
    case today = "오늘까지"
    case manual = "직접 입력"
    
    var date: Date? {
        switch self {
        case .none:
            return nil
        case .today:
            return Date()
        case .manual:
            return nil
        }
    }
}
