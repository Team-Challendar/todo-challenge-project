//
//  DateCalendarView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
import SnapKit
import FSCalendar

class TodoCalendarView: UIView {
    var dayModelForCurrentPage : [Day]?
    var calendar = FSCalendar(frame: .zero)
    var calendarLabel = UILabel()
    var prevButton = UIButton()
    var nextButton = UIButton()
    var currentState : currentCalendar?
    var selectedDate : Date?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraint()
        configureNotificationCenter()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureConstraint()
        configureNotificationCenter()
    }
    
    func configureNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataChanged), name: NSNotification.Name("CoreDataChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(calendarToggle(notification:)), name: NSNotification.Name("CalendarToggle"), object: currentState)
    }
    
    private func configureUI(){
        calendar.scope = .month
        calendarLabel.text = DateFormatter.dateFormatter.string(from: Date())
        calendarLabel.font = .pretendardBold(size: 22)
        calendarLabel.backgroundColor = .clear
        calendarLabel.textColor = .challendarWhite
        updateLabel(Date())
        prevButton.setImage(.arrowLeftNew, for: .normal)
        prevButton.backgroundColor = .clear
        prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        nextButton.setImage(.arrowRight, for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .challendarBlack80
        self.clipsToBounds = true
        
        //MARK: - 헤더뷰 설정
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerTitleColor = .clear
        calendar.headerHeight = 0
        
        //MARK: -캘린더 관련
        calendar.register(TodoCalendarFSCell.self, forCellReuseIdentifier: TodoCalendarFSCell.identifier)
        calendar.backgroundColor = .challendarBlack80
        calendar.weekdayHeight = 44
        calendar.appearance.weekdayTextColor = .challendarWhite
        calendar.appearance.titleWeekendColor = .challendarWhite
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor  = .none
        calendar.appearance.titlePlaceholderColor = .challendarCalendarPlaceholder
        calendar.appearance.todayColor = .clear
        calendar.scrollDirection = .horizontal
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .challendarWeekend
        calendar.calendarWeekdayView.weekdayLabels.forEach{
            $0.adjustTextPosition(top: -4, right: 0)
        }
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .challendarWeekend
        calendar.placeholderType = .fillSixRows
        calendar.allowsMultipleSelection = false
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    private func configureConstraint(){
        [calendar,calendarLabel,prevButton,nextButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        calendar.snp.makeConstraints{
            $0.height.equalTo(332)
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(calendarLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(19)
        }
        calendarLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
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
        if calendar.scope == .month{
            if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage) {
                calendar.setCurrentPage(previousMonth, animated: true)
                updateLabel(previousMonth)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: previousMonth, userInfo: nil)
                selectedDate = previousMonth
                calendar.reloadData()
            }
        }else{
            if let prevWeek = Calendar.current.date(byAdding: .day, value: -7, to: calendar.currentPage) {
                calendar.setCurrentPage(prevWeek, animated: true)
                updateLabel(prevWeek)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: prevWeek, userInfo: nil)
                selectedDate = prevWeek
                calendar.reloadData()
            }
        }
        
    }
    
    @objc func nextButtonClicked(){
        if calendar.scope == .month{
            if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage) {
                calendar.setCurrentPage(nextMonth, animated: true)
                updateLabel(nextMonth)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: nextMonth, userInfo: nil)
                selectedDate = nextMonth
                calendar.reloadData()
            }
        }else{
            if let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: calendar.currentPage) {
                calendar.setCurrentPage(nextWeek, animated: true)
                updateLabel(nextWeek)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: nextWeek, userInfo: nil)
                selectedDate = nextWeek
                calendar.reloadData()
            }
        }
    }
    
    func updateLabel(_ date: Date) {
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        calendarLabel.attributedText = attributedString
    }

    @objc func coreDataChanged(){
        calendar.reloadData()
    }
    
    @objc func calendarToggle(notification: Notification){
        guard let state = notification.object as? currentCalendar else {return}
        currentState = state
        switch currentState {
        case .calendar:
            calendar.setScope(.month, animated: true)
        case .daily:
            calendar.setScope(.week, animated: true)
        default:
            return
        }
    }
}

extension TodoCalendarView : FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //        calendarView.snp.updateConstraints{
        //            $0.bottom.equalToSuperview().inset(10)
        //            $0.leading.equalToSuperview().inset(20)
        //            $0.top.equalTo(calendarLabel.snp.bottom).offset(8)
        //            $0.trailing.equalToSuperview().inset(19)
        //        }
        
        UIView.animate(withDuration: 0.5) {
            if calendar.scope == .month {
                calendar.snp.updateConstraints{
                    $0.height.equalTo(332)
                }
            }else{
                calendar.snp.updateConstraints{
                    $0.height.equalTo(102)
                }
            }
            self.layoutIfNeeded()
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print(DateFormatter.dateFormatterALL.string(from: date))
        selectedDate = date
        NotificationCenter.default.post(name: NSNotification.Name("date"), object: calendar.selectedDate, userInfo: nil)
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        updateLabel(date)
        NotificationCenter.default.post(name: NSNotification.Name("date"), object: date, userInfo: nil)
        calendar.reloadData()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        switch calendar.scope{
        case .month:
            if date.isSameDay(as: selectedDate ?? Date()) {
                return .challendarWhite
            }
            if !date.isSameMonth(as: calendar.currentPage){
                return .challendarCalendarPlaceholder
            }else{
                if let day = dayModelForCurrentPage?.first(where: {
                    $0.date.isSameDay(as: date)
                }){
                    switch day.percentage{
                    case 0:
                        if day.date < Date(){
                            return .challendarPastDay
                        }else{
                            return .challendarWhite
                        }
                        
                    default:
                        return .challendarBlack100
                    }
                }
                else{
                    return .challendarWhite
                }
            }
        case .week:
            if date.isSameDay(as: selectedDate ?? Date()) {
                return .challendarWhite
            }
            if let day = dayModelForCurrentPage?.first(where: {
                $0.date.isSameDay(as: date)
            }){
                switch day.percentage{
                case 0:
                    if day.date < Date(){
                        return .challendarPastDay
                    }else{
                        return .challendarWhite
                    }
                    
                default:
                    return .challendarBlack100
                }
                
            }
            else{
                return .challendarWhite
            }
        @unknown default:
            return .challendarWhite
        }
        
    }
    
}

extension TodoCalendarView : FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TodoCalendarFSCell.identifier, for: date, at: position) as? TodoCalendarFSCell else { return FSCalendarCell() }
        
        if let day = dayModelForCurrentPage?.first(where: {
            $0.date.isSameDay(as: date) && date.isSameMonth(as: calendar.currentPage)
        }){
            cell.setViewWithData(day: day)
            if let selectedDate = selectedDate {
                if date.isSameDay(as: selectedDate){
                    cell.selectDate()
                }
            }else{
                if date.isSameDay(as: Date()){
                    cell.selectDate()
                }
            }
        }
        if date.isSameDay(as: Date()){
            cell.setTodayView()
        }
        return cell
        
    }
}

