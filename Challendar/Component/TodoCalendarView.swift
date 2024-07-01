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
    var selectedDate : Date? {
        didSet {
            calendar.reloadData()
        }
    }
    
    // 초기화 메서드
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
    
    // 알림센터 설정
    func configureNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataChanged), name: NSNotification.Name("CoreDataChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(calendarToggle(notification:)), name: NSNotification.Name("CalendarToggle"), object: currentState)
    }
    
    // UI 구성 설정
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
        self.backgroundColor = .secondary850
        self.clipsToBounds = true
        
        // 헤더뷰 설정
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerTitleColor = .clear
        calendar.headerHeight = 0
        
        // 캘린더 관련 설정
        calendar.register(TodoCalendarFSCell.self, forCellReuseIdentifier: TodoCalendarFSCell.identifier)
        calendar.backgroundColor = .secondary850
        calendar.weekdayHeight = 44
        calendar.appearance.weekdayTextColor = .challendarWhite
        calendar.appearance.titleWeekendColor = .challendarWhite
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor  = .challendarWhite
        calendar.appearance.todayColor = .clear
        calendar.scrollDirection = .horizontal
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .secondary500
        calendar.calendarWeekdayView.weekdayLabels.forEach{
            $0.adjustTextPosition(top: -4, right: 0)
        }
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .secondary500
        calendar.placeholderType = .fillSixRows
        calendar.allowsMultipleSelection = false
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    // UI 제약 조건 설정
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
    
    // 이전 버튼 클릭 핸들러
    @objc func prevButtonClicked(){
        if calendar.scope == .month{
            if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage) {
                calendar.setCurrentPage(previousMonth, animated: true)
                updateLabel(previousMonth)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: previousMonth, userInfo: nil)
                selectedDate = previousMonth
                calendar.reloadData()
            }
        } else {
            if let prevWeek = Calendar.current.date(byAdding: .day, value: -7, to: calendar.currentPage) {
                calendar.setCurrentPage(prevWeek, animated: true)
                updateLabel(prevWeek)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: prevWeek, userInfo: nil)
                selectedDate = prevWeek
                calendar.reloadData()
            }
        }
    }
    
    // 다음 버튼 클릭 핸들러
    @objc func nextButtonClicked(){
        if calendar.scope == .month{
            if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage) {
                calendar.setCurrentPage(nextMonth, animated: true)
                updateLabel(nextMonth)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: nextMonth, userInfo: nil)
                selectedDate = nextMonth
                calendar.reloadData()
            }
        } else {
            if let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: calendar.currentPage) {
                calendar.setCurrentPage(nextWeek, animated: true)
                updateLabel(nextWeek)
                NotificationCenter.default.post(name: NSNotification.Name("date"), object: nextWeek, userInfo: nil)
                selectedDate = nextWeek
                calendar.reloadData()
            }
        }
    }
    
    // 라벨 업데이트
    func updateLabel(_ date: Date) {
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        calendarLabel.attributedText = attributedString
    }
    
    // CoreData 변경 시 호출
    @objc func coreDataChanged(){
        DispatchQueue.main.async{
            self.calendar.reloadData()
        }
        
    }
    
    // 캘린더 토글
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
    // 캘린더 크기 변경 시 호출
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            if calendar.scope == .month {
                calendar.snp.updateConstraints{
                    $0.height.equalTo(332)
                }
            } else {
                calendar.snp.updateConstraints{
                    $0.height.equalTo(102)
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    // 날짜 선택 시 호출
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !date.isSameMonth(as: calendar.currentPage){
            calendar.setCurrentPage(date, animated: true)
            calendar.select(date)
        }
        updateLabel(date)
        NotificationCenter.default.post(name: NSNotification.Name("date"), object: calendar.selectedDate, userInfo: nil)
    }
    
    // 날짜 선택 해제 시 호출
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {}
    
    // 현재 페이지 변경 시 호출
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if !calendar.currentPage.isSameMonth(as: selectedDate!) {
            let date = calendar.currentPage
            selectedDate = date
            updateLabel(selectedDate!)
            NotificationCenter.default.post(name: NSNotification.Name("date"), object: date, userInfo: nil)
        } else {
            updateLabel(selectedDate!)
            NotificationCenter.default.post(name: NSNotification.Name("date"), object: selectedDate, userInfo: nil)
        }
    }
    
    // 날짜 텍스트 색상 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        switch calendar.scope {
        case .month:
            if date.isSameDay(as: selectedDate ?? Date()) {
                return .challendarWhite
            }
            if !date.isSameMonth(as: calendar.currentPage){
                return .secondary800
            } else {
                if let day = dayModelForCurrentPage?.first(where: {
                    $0.date.isSameDay(as: date)
                }) {
                    switch day.percentage {
                    case 0:
                        if day.date < Date(){
                            return .challendarWhite
                        } else {
                            return .challendarWhite
                        }
                    default:
                        return .challendarBlack
                    }
                } else {
                    return .challendarBlack
                }
            }
        case .week:
            if date.isSameDay(as: selectedDate ?? Date()) {
                return .challendarWhite
            }
            if !date.isSameMonth(as: self.selectedDate!){
                return .secondary800
            } else {
                if let day = dayModelForCurrentPage?.first(where: {
                    $0.date.isSameDay(as: date)
                }) {
                    switch day.percentage {
                    case 0:
                        if day.date < Date(){
                            return .challendarWhite
                        } else {
                            return .challendarWhite
                        }
                    default:
                        return .challendarBlack
                    }
                } else {
                    return .challendarBlack
                }
            }
        @unknown default:
            return .challendarWhite
        }
    }
}

extension TodoCalendarView : FSCalendarDataSource {
    // 캘린더 셀 설정
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TodoCalendarFSCell.identifier, for: date, at: position) as? TodoCalendarFSCell else { return FSCalendarCell() }
        switch calendar.scope {
        case .month:
            if let day = dayModelForCurrentPage?.first(where: {
                $0.date.isSameDay(as: date) && $0.date.isSameMonth(as: selectedDate ?? Date())
            }) {
                cell.setViewWithData(day: day)
                if let selectedDate = selectedDate {
                    if date.isSameDay(as: selectedDate) {
                        cell.selectDate()
                    }
                } else {
                    if date.isSameDay(as: Date()) {
                        cell.selectDate()
                    }
                }
            }
            if date.isSameDay(as: Date()) {
                cell.setTodayView()
            }
            return cell
        case .week:
            if let day = dayModelForCurrentPage?.first(where: {
                $0.date.isSameDay(as: date)
            }) {
                cell.setViewWithData(day: day)
                if let selectedDate = selectedDate {
                    if date.isSameDay(as: selectedDate) {
                        cell.selectDate()
                    }
                } else {
                    if date.isSameDay(as: Date()) {
                        cell.selectDate()
                    }
                }
            }
            if date.isSameDay(as: Date()) {
                cell.setTodayView()
            }
            return cell
        @unknown default:
            return FSCalendarCell()
        }
    }
}
