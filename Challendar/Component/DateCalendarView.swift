//
//  DateCalendarView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
import SnapKit
import FSCalendar

class DateCalendarView: UIView {
    
    var calendarView = FSCalendar(frame: .zero)
    var calendarLabel = UILabel()
    var prevButton = UIButton()
    var nextButton = UIButton()
    private var firstDate: Date?
    private var lastDate: Date?

    private var datesRange: [Date] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraint()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureConstraint()
    }
    
    private func configureUI(){
        
        calendarLabel.text = DateFormatter.dateFormatter.string(from: Date())
        calendarLabel.font = .pretendardBold(size: 22)
        calendarLabel.backgroundColor = .clear
        calendarLabel.textColor = .challendarWhite100
        
        prevButton.setImage(.arrowLeft, for: .normal)
        prevButton.backgroundColor = .clear
        prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        nextButton.setImage(.arrowRight, for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        self.layer.cornerRadius = 20
        self.backgroundColor = .challendarBlack80
        self.clipsToBounds = true
        
        //MARK: - 헤더뷰 설정
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleColor = .clear
        calendarView.headerHeight = 42
        
        //MARK: -캘린더 관련
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        calendarView.backgroundColor = .challendarBlack80
        calendarView.weekdayHeight = 46
        calendarView.appearance.weekdayTextColor = .challendarWhite100
        calendarView.appearance.titleWeekendColor = .challendarWhite100
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor  = .challendarBlack100
        calendarView.appearance.titlePlaceholderColor = .challendarCalendarPlaceholder
        calendarView.appearance.todayColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .challendarWeekend
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .challendarWeekend
        calendarView.placeholderType = .fillSixRows
        calendarView.allowsMultipleSelection = true
        calendarView.delegate = self
        calendarView.dataSource = self
        
    }
    
    private func configureConstraint(){
        [calendarView,calendarLabel,prevButton,nextButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        calendarView.snp.makeConstraints{
            $0.top.leading.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        calendarLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(26)
            $0.leading.equalToSuperview().offset(20)
        }
        nextButton.snp.makeConstraints{
            $0.size.equalTo(32)
            $0.centerY.equalTo(calendarLabel)
            $0.trailing.equalToSuperview().inset(19)
        }
        prevButton.snp.makeConstraints{
            $0.size.equalTo(32)
            $0.centerY.equalTo(calendarLabel)
            $0.trailing.equalTo(nextButton.snp.leading).offset(-8)
        }
    }
    
    @objc func prevButtonClicked(){
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(previousMonth, animated: true)
            updateLabel(previousMonth)
        }
    }
    
    @objc func nextButtonClicked(){
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(nextMonth, animated: true)
            updateLabel(nextMonth)
        }
    }
    
    func updateLabel(_ date: Date){
        calendarLabel.text = DateFormatter.dateFormatter.string(from: date)
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
                calendar.reloadData()    // (매번 reload)
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
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if !date.isSameMonth(as: calendar.currentPage){
            return .challendarCalendarPlaceholder
        }
        if datesRange.contains(where: { $0 == date }){
            return .challendarBlack100
        }else{
            return .challendarWhite100
        }
    }
    
}

extension DateCalendarView : FSCalendarDataSource {
    func typeOfDate(_ date: Date) -> SelectedDateType {
        let arr = datesRange
        if !arr.contains(date) {
            return .notSelectd
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
        
        return cell
    }
}
