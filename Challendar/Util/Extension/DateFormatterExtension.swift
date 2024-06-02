import Foundation

extension DateFormatter {
    static var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 YYYY"
        return dateFormatter
    }
}
