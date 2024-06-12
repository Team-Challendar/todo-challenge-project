//
//  CalendarCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/1/24.
//

import UIKit
import SnapKit
import FSCalendar

class TodoCalendarFSCell: FSCalendarCell {
    static var identifier = "TodoCalendarFSCell"
    var circleView = UIView()
    var selectedView = UIView()
    var todayView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
    }
    
    func setView(){
        todayView.layer.cornerRadius = 2
        todayView.layer.cornerCurve = .continuous
        todayView.clipsToBounds = true
        circleView.layer.cornerRadius = 12
        circleView.layer.cornerCurve = .continuous
        circleView.clipsToBounds = true
        selectedView.layer.cornerRadius = 15
        selectedView.layer.cornerCurve = .continuous
        selectedView.clipsToBounds = true
        [todayView, selectedView, circleView].forEach{
            contentView.insertSubview($0, at: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        selectedView.backgroundColor = .clear
        circleView.backgroundColor = .clear
        todayView.backgroundColor = .clear
        self.titleLabel.textAlignment = .center
    }
    
    func setConstraint(){
        self.titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        todayView.snp.makeConstraints{
            $0.size.equalTo(4)
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView).offset(10)
        }
        selectedView.snp.makeConstraints{
            $0.size.equalTo(30)
            $0.center.equalTo(contentView)
        }

        circleView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(44)
        }
    }
    
    func setViewWithData(day: Day){
        circleView.backgroundColor = colorByPercentage(percentage: day.percentage)
    }
    func setTodayView(){
        todayView.backgroundColor = .alertTomato
    }
    func selectDate(){
        selectedView.backgroundColor = .challendarBlack100
    }
    private func colorByPercentage(percentage : Double) -> UIColor {
        switch percentage{
        case 0:
            return .clear
        case 0..<20:
            return .challendarBlue100
        case 20..<40:
            return .challendarBlue200
        case 40..<60:
            return .challendarBlue300
        case 60..<80:
            return .challendarBlue400
        case 80..<100:
            return .challendarBlue500
        case 100:
            return .challendarBlue600
        default:
            return .clear
        }
    }
    
    func setViewByComplete(day: Day) {
//        circleView.backgroundColor = colorByComplete(completed: challenge.completed)
    }
    
    private func colorByComplete(completed: [Bool]) -> [UIColor] {
        var dateColor: [UIColor] = []
        for complete in completed {
            if complete == true {
                dateColor.append(.challendarGreen100)
            } else {
                dateColor.append(.clear)
            }
        }
        return dateColor
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleView.backgroundColor = .clear
        selectedView.backgroundColor = .clear
        todayView.backgroundColor = .clear
    }
    
}
