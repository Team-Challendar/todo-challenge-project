//
//  ChallengeDateCalendarView.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/4/24.
//

import UIKit
import SnapKit
import FSCalendar

class ChallengeDateCalendarView: UIView {
    var calendarView = FSCalendar(frame: .zero)
    var calendarLabel = UILabel()
    var prevButton = UIButton()
    var nextButton = UIButton()
    var currentTodo : Todo?
    var selectedDate : Date = Date()
    
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
        calendarLabel.textColor = .challendarWhite
        updateLabel(Date())
        prevButton.setImage(.arrowLeftNew, for: .normal)
        prevButton.backgroundColor = .clear
        
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
        
        //MARK: - 헤더뷰 설정
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleColor = .clear
        calendarView.headerHeight = 0
        
        //MARK: -캘린더 관련
        calendarView.register(TodoCalendarFSCell.self, forCellReuseIdentifier: TodoCalendarFSCell.identifier)
        calendarView.backgroundColor = .secondary850
        calendarView.weekdayHeight = 44
        calendarView.appearance.weekdayTextColor = .challendarWhite
        calendarView.appearance.titleWeekendColor = .challendarWhite
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor = .none
        calendarView.appearance.titlePlaceholderColor = .white
        calendarView.appearance.todayColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .secondary500
        calendarView.calendarWeekdayView.weekdayLabels.forEach{
            $0.adjustTextPosition(top: -4, right: 0)
        }
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .secondary500
        calendarView.placeholderType = .fillSixRows
        calendarView.allowsMultipleSelection = false
        calendarView.delegate = self
        calendarView.dataSource = self
        
    }
    
    private func configureConstraint(){
        [calendarView,calendarLabel,prevButton,prevButton,nextButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        calendarView.snp.makeConstraints{
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
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(previousMonth, animated: true)
            updateLabel(previousMonth)
            calendarView.reloadData()
        }
    }
    
    @objc func nextButtonClicked(){
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(nextMonth, animated: true)
            updateLabel(nextMonth)
            calendarView.reloadData()
        }
    }
    
    func updateLabel(_ date: Date){
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        calendarLabel.attributedText = attributedString
    }
}

extension ChallengeDateCalendarView : FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        calendar.deselect(selectedDate)
        selectedDate = date
        calendar.select(selectedDate)
        updateLabel(selectedDate)
        calendar.reloadData()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if !date.isSameMonth(as: calendar.currentPage){
            return .secondary800
        }
        if date.isSameDay(as: selectedDate) {
            return .challendarWhite
        }
        if let completed = self.currentTodo?.todayCompleted(date: date) {
            if date < Date(){
                return completed ? .challendarBlack : .secondary500
            }else{
                return completed ? .challendarBlack : .challendarWhite
            }
        }
        return .white
    }
}


extension ChallengeDateCalendarView : FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TodoCalendarFSCell.identifier, for: date, at: position) as? TodoCalendarFSCell else { return FSCalendarCell() }
        
        cell.setViewByComplete(completed: self.currentTodo?.todayCompleted(date: date) ?? false, date: date)
        if date.isSameDay(as: selectedDate){
            cell.selectDate()
        }
        return cell
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !date.isSameMonth(as: calendar.currentPage){
            calendar.setCurrentPage(date, animated: true)
            calendar.select(date)
        }
        selectedDate = date
        calendar.reloadData()
    }
}
