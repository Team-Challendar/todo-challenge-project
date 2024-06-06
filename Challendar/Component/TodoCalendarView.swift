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
    var calendarView = FSCalendar(frame: .zero)
    var calendarLabel = UILabel()
    var prevButton = UIButton()
    var nextButton = UIButton()
    
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
    }
    
    private func configureUI(){
        calendarView.scope = .month
        calendarLabel.text = DateFormatter.dateFormatter.string(from: Date())
        calendarLabel.font = .pretendardBold(size: 22)
        calendarLabel.backgroundColor = .clear
        calendarLabel.textColor = .challendarWhite100
        
        prevButton.setImage(.arrowLeftNew, for: .normal)
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
        calendarView.headerHeight = 0
        
        //MARK: -캘린더 관련
        calendarView.register(TodoCalendarFSCell.self, forCellReuseIdentifier: TodoCalendarFSCell.identifier)
        calendarView.backgroundColor = .challendarBlack80
        calendarView.weekdayHeight = 44
        calendarView.appearance.weekdayTextColor = .challendarWhite100
        calendarView.appearance.titleWeekendColor = .challendarWhite100
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor  = .red
        calendarView.appearance.titlePlaceholderColor = .challendarCalendarPlaceholder
        calendarView.appearance.todayColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .challendarWeekend
        calendarView.calendarWeekdayView.weekdayLabels.forEach{
            $0.adjustTextPosition(top: -4, right: 0)
        }
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .challendarWeekend
        calendarView.placeholderType = .fillSixRows
        calendarView.allowsMultipleSelection = false
        calendarView.delegate = self
        calendarView.dataSource = self
        
    }
    
    private func configureConstraint(){
        [calendarView,calendarLabel,prevButton,nextButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        calendarView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
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
            NotificationCenter.default.post(name: NSNotification.Name("month"), object: previousMonth, userInfo: nil)
            calendarView.reloadData()
        }
    }
    
    @objc func nextButtonClicked(){
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(nextMonth, animated: true)
            updateLabel(nextMonth)
            NotificationCenter.default.post(name: NSNotification.Name("month"), object: nextMonth, userInfo: nil)
            calendarView.reloadData()
        }
    }
    
    func updateLabel(_ date: Date){
        calendarLabel.text = DateFormatter.dateFormatter.string(from: date)
    }
    @objc func coreDataChanged(){
        calendarView.reloadData()
    }
}

extension TodoCalendarView : FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print(DateFormatter.dateFormatterALL.string(from: date))
        NotificationCenter.default.post(name: NSNotification.Name("date"), object: calendar.selectedDate, userInfo: nil)
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        updateLabel(date)
        NotificationCenter.default.post(name: NSNotification.Name("month"), object: date, userInfo: nil)
        calendar.reloadData()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if !date.isSameMonth(as: calendar.currentPage){
            return .challendarCalendarPlaceholder
        }else{
            if let day = dayModelForCurrentPage?.first(where: {
                $0.date.isSameDay(as: date)
            }){
                if day.date.isSameDay(as: Date()){
                    return .challendarWhite100
                }else{
                    switch day.percentage{
                    case 0:
                        if day.date < Date(){
                            return .challendarPastDay
                        }else{
                            return .challendarWhite100
                        }
                        
                    default:
                        return .challendarBlack100
                    }
                }
            }
            else{
                return .challendarWhite100
            }
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
        }
        
        return cell

    }
}

