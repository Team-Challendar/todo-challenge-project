import Foundation

extension DateFormatter {
    static var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 YYYY"
        return dateFormatter
    }
    static var dateFormatterDay : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ko_KR")
        dateFormatter.dateFormat = "YYYY년 M월 dd일"
        return dateFormatter
    }
    static var dateFormatterALL : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ko_KR")
        dateFormatter.dateFormat = "YYYY년 M월 dd일 HH:mm"
        return dateFormatter
    }
}
