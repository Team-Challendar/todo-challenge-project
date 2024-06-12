//
//  DateCalendarView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa

class DateCalendarView: UIView {
    var delegate : DateRangeProtocol?
    var calendarView = FSCalendar(frame: .zero)
    var emptyView = UIView()
    var calendarLabel = UILabel()
    var prevButton = UIButton()
    var confirmButton = UIButton()
    var disposeBag = DisposeBag()
    var newTodo: Todo?
    var firstDate: Date?
    var lastDate: Date?
    private var datesRange: [Date] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraint()
        configureUtil()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureConstraint()
        configureUtil()
    }
    
    private func configureUI(){
        emptyView.backgroundColor = .secondary850
        emptyView.layer.cornerRadius = 2.5
        emptyView.clipsToBounds = true
        
        calendarLabel.text = DateFormatter.dateFormatter.string(from: Date())
        calendarLabel.font = .pretendardMedium(size: 20)
        calendarLabel.backgroundColor = .clear
        calendarLabel.textColor = .challendarWhite
        
        prevButton.setImage(.arrowLeftNew, for: .normal)
        prevButton.backgroundColor = .clear
        
        confirmButton.setTitle("선택", for: .normal)
        confirmButton.setTitleColor(.secondary700, for: .normal)
        confirmButton.backgroundColor = .clear
        confirmButton.titleLabel?.font = .pretendardSemiBold(size: 16)
        confirmButton.isEnabled = false
        
        self.layer.cornerRadius = 20
        self.backgroundColor = .secondary850
        self.clipsToBounds = true
        
        //MARK: - 헤더뷰 설정
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleColor = .clear
        calendarView.headerHeight = 0
        //MARK: -캘린더 관련
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        calendarView.backgroundColor = .secondary850
        calendarView.weekdayHeight = 46
        calendarView.rowHeight = 46
        calendarView.appearance.weekdayTextColor = .challendarWhite
        calendarView.appearance.titleWeekendColor = .challendarWhite
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor = .challendarBlack
        calendarView.appearance.titlePlaceholderColor = .white
        calendarView.appearance.todayColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.calendarWeekdayView.weekdayLabels.forEach{
            $0.font = .pretendardSemiBold(size: 13)
        }
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .secondary500
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .secondary500
        calendarView.placeholderType = .fillSixRows
        calendarView.allowsMultipleSelection = true
        calendarView.delegate = self
        calendarView.dataSource = self
        
    }
    
    private func configureConstraint(){
        [calendarView,calendarLabel,prevButton,confirmButton,emptyView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        emptyView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
            $0.width.equalTo(36)
            $0.height.equalTo(5)
        }
        
        calendarView.snp.makeConstraints{
            $0.top.equalTo(calendarLabel.snp.bottom).offset(17)
            $0.trailing.leading.equalToSuperview().inset(35.5)
            $0.bottom.equalToSuperview().inset(40)
        }
        calendarLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        prevButton.snp.makeConstraints{
            $0.size.equalTo(24)
            $0.centerY.equalTo(calendarLabel)
            $0.leading.equalToSuperview().offset(35.5)
        }
        confirmButton.snp.makeConstraints{
            $0.centerY.equalTo(calendarLabel)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(37.5)
        }
    }
    
    func updateLabel(_ date: Date){
        calendarLabel.text = DateFormatter.dateFormatter.string(from: date)
    }
    private func configureUtil(){
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.dateSetFromCal(startDate: self?.firstDate?.startOfDay(), endDate: self?.lastDate?.endOfDay())
            }).disposed(by: self.disposeBag)
    }
}

extension DateCalendarView : FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        confirmButton.setTitleColor(.secondary600, for: .normal)
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            calendar.reloadData()
            return
        }
        
        if firstDate != nil && lastDate == nil {
            if date < firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                calendar.reloadData()
                return
            }else {
                var range: [Date] = []
                var currentDate = firstDate!
                while currentDate <= date {
                    range.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                for day in range {
                    calendar.select(day)
                }
                lastDate = range.last
                datesRange = range
                confirmButton.setTitleColor(.challendarGreen200, for: .normal)
                confirmButton.isEnabled = true
                calendar.reloadData()
                return
            }
        }
        if firstDate != nil && lastDate != nil {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            lastDate = nil
            firstDate = date
            calendar.select(date)
            datesRange = [firstDate!]
            calendar.reloadData()    // (매번 reload)
            return
        }
        
        
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let arr = datesRange
        if !arr.isEmpty {
            for day in arr {
                calendar.deselect(day)
            }
        }
        firstDate = nil
        lastDate = nil
        datesRange = []
        calendar.reloadData()    // (매번 reload)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        updateLabel(date)
        calendar.reloadData()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if !date.isSameMonth(as: calendar.currentPage){
            return .secondary800
        }
        
        if datesRange.contains(where: { $0 == date }){
            return .challendarBlack
        }else{
            return .challendarWhite
        }
    }
}

extension DateCalendarView : FSCalendarDataSource {
    func typeOfDate(_ date: Date) -> SelectedDateType {
        let arr = datesRange
        if !arr.contains(date) {
            return .notSelected
        }
        else {
            if arr.count == 1 && date == firstDate { return .singleDate }
            if date == firstDate { return .firstDate }
            if date == lastDate { return .lastDate }
            else { return .middleDate }
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        cell.updateBackImage(typeOfDate(date))
        if date.isSameDay(as: Date()){
            cell.updateToday(typeOfDate(date))
        }
        
        return cell
    }
}
