//
//  NewCalendarView.swift
//  Challendar
//
//  Created by Sam.Lee on 6/20/24.
//
import UIKit
import SnapKit
import FSCalendar

protocol NewCalendarDelegate {
    func singleDateSelected(firstDate : Date)
    func rangeOfDateSelected(firstDate: Date, lastDate: Date)
    func deSelectedDate()
}

// Ver 2.0 추가/ 수정 페이지용 CalendarView
class NewCalendarView : UIView {
    // UI
    var calendarView = FSCalendar(frame: .zero) // 달력부분
    var calendarLabel = UILabel() // 월 년도 표시 Label
    var prevButton = UIButton() // 이전 달 버튼
    var nextButton = UIButton() // 다음 달 버튼
    var todayButton = UIButton() // 오늘날짜 버튼
    // Data
    
    // Delegate
    var delegate : NewCalendarDelegate?
    // 선택한 시작날짜
    var firstDate: Date? {
        didSet{
            print("FirstDate: \(firstDate?.dateToString())")
        }
    }
    // 선택한 종료 날짜
    var lastDate: Date? {
        didSet{
            print("LastDate: \(lastDate?.dateToString())")
        }
    }
    var datesRange: [Date] = [] // 시작날짜 ~ 종료날짜 사이 날짜들
    var isChallenge : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
        configureUtil()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureWithTodo(todo: Todo) {
        isChallenge = todo.isChallenge
        if let startDate = todo.startDate, let endDate = todo.endDate {
            self.firstDate = startDate.startOfDay()
            self.lastDate = endDate.startOfDay()
            var range: [Date] = []
            var currentDate = firstDate!
            while currentDate <= lastDate! {
                range.append(currentDate)
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
            for day in range {
                calendarView.select(day)
            }
            datesRange = range
            calendarView.reloadData()
        }
    }
    func configureUI(){
        //View UI 구성
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .secondary850
        self.layer.borderColor = UIColor.secondary800.cgColor
        self.clipsToBounds = true
        
        // 월 년도 표시 Label
        calendarLabel.text = DateFormatter.dateFormatter.string(from: Date())
        calendarLabel.font = .pretendardSemiBold(size: 20)
        calendarLabel.backgroundColor = .clear
        calendarLabel.textColor = .challendarWhite
        self.updateLabel(Date())
        
        // 이전 달 버튼
        prevButton.setImage(.arrowLeftNew, for: .normal)
        prevButton.backgroundColor = .clear
        
        // 다음 달 버튼
        nextButton.setImage(.arrowRight, for: .normal)
        nextButton.backgroundColor = .clear
        
        // 오늘 버튼
        todayButton.setTitle("오늘", for: .normal)
        todayButton.titleLabel?.textColor = .challendarWhite
        todayButton.backgroundColor = .clear
        todayButton.titleLabel?.font = .pretendardSemiBold(size: 10)
        
        //MARK: - 헤더뷰 설정
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerTitleColor = .clear
        calendarView.headerHeight = 0
        //MARK: -캘린더 관련
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        calendarView.backgroundColor = .secondary850
        calendarView.weekdayHeight = 44
        calendarView.rowHeight = 44
        calendarView.appearance.weekdayTextColor = .challendarWhite
        calendarView.appearance.titleWeekendColor = .challendarWhite
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleSelectionColor = .challendarBlack
        calendarView.appearance.titlePlaceholderColor = .white
        calendarView.appearance.todayColor = .clear
        calendarView.scrollDirection = .horizontal
        calendarView.calendarWeekdayView.weekdayLabels.forEach{
            $0.font = .pretendardRegular(size: 13)
        }
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .secondary500
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .secondary500
        calendarView.placeholderType = .fillSixRows
        calendarView.allowsMultipleSelection = true
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    func configureConstraint(){
        // View에 Subview에 추가
        [calendarView,calendarLabel,prevButton,nextButton,todayButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        // 달력 Constriant
        calendarView.snp.makeConstraints{
            $0.height.equalTo(252)
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(calendarLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
        // 날짜 label Constriant
        calendarLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
        }
        // 다음달 버튼 Constriant
        nextButton.snp.makeConstraints{
            $0.size.equalTo(24)
            $0.centerY.equalTo(calendarLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        // 오늘 버튼 Constriant
        todayButton.snp.makeConstraints{
            $0.width.equalTo(34)
            $0.centerY.equalTo(calendarLabel)
            $0.height.equalTo(nextButton)
            $0.trailing.equalTo(nextButton.snp.leading).inset(0)
        }
        // 이전 달 버튼 Constraint
        prevButton.snp.makeConstraints{
            $0.size.equalTo(24)
            $0.centerY.equalTo(calendarLabel)
            $0.trailing.equalTo(todayButton.snp.leading).offset(0)
        }
    }
    
    func configureUtil(){
        prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(todayButtonClicked), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    // 라벨 업데이트 (현재 달력 월/ 년도 표시용)
    func updateLabel(_ date: Date) {
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        calendarLabel.attributedText = attributedString
    }
    
    @objc func nextButtonClicked(){
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(nextMonth, animated: true)
            updateLabel(nextMonth)
            calendarView.reloadData()
        }
    }
    @objc func prevButtonClicked(){
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage) {
            calendarView.setCurrentPage(previousMonth, animated: true)
            updateLabel(previousMonth)
            calendarView.reloadData()
        }
    }
    @objc func todayButtonClicked(){
        calendarView.setCurrentPage(Date(), animated: true)
        updateLabel(Date())
        calendarView.reloadData()
    }
}


extension NewCalendarView : FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    // 캘린더 크기 변경 시 호출
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.layoutIfNeeded()
    }
    
    // 범위 설정 select
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택한 날짜가 이번달이 아니면 페이지 넘기기
        if !date.isSameMonth(as: calendar.currentPage){
            calendar.setCurrentPage(date, animated: true)
        }
        // 첫번째 날짜 고를때 호출
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            self.delegate?.singleDateSelected(firstDate: date)
            calendar.reloadData()
            return
        }
        // 첫번째 날짜는 골라져있는 상태이고, 범위 날짜 선택한 경우
        if firstDate != nil && lastDate == nil {
            if date < firstDate! {
                // 선택한 날짜가 첫 번째 날짜보다 이전인 경우
                lastDate = firstDate
                firstDate = date
            } else {
                // 선택한 날짜가 첫 번째 날짜보다 이후인 경우
                lastDate = date
            }
            
            var range: [Date] = []
            var currentDate = firstDate!
            while currentDate <= lastDate! {
                range.append(currentDate)
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
            for day in range {
                calendar.select(day)
            }
            self.delegate?.rangeOfDateSelected(firstDate: firstDate!, lastDate: lastDate!)
            datesRange = range
            calendar.reloadData()
            return
        }
        // 범위가 설정되어 있을때는, 다른거 누르면 호출
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
    
    // 같은 Cell 클릭시 Deselect
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.delegate?.deSelectedDate()
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
    // 월 변경시 호출되는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage
        updateLabel(date)
        calendar.reloadData()
    }
    // 날짜 별로 색깔
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
    //선택한 날짜인지, 중간 날짜 인지 확인하는 함수
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
    // 날짜 별로 Cell 그리는 함수
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        cell.setColor(isChallenge: isChallenge)
        cell.updateBackImage(typeOfDate(date))
        if date.isSameDay(as: Date()){
            cell.updateToday(typeOfDate(date))
        }
        
        return cell
    }
}
