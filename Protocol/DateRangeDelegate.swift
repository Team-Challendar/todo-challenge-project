import Foundation

protocol DateRangeProtocol {
    func dateRangeChanged(dateRange : DateRange?)
    func dateSetFromCal(startDate : Date?, endDate: Date?)
}
