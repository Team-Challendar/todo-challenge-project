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
    var todayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
    }
    
    func setView(){
        circleView.layer.cornerRadius = 12
        circleView.layer.cornerCurve = .continuous
        circleView.clipsToBounds = true
        todayView.layer.cornerRadius = 15
        todayView.layer.cornerCurve = .continuous
        todayView.clipsToBounds = true
        [todayView, circleView].forEach{
            contentView.insertSubview($0, at: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        todayView.backgroundColor = .clear
        circleView.backgroundColor = .clear
        self.titleLabel.textAlignment = .center
    }
    
    func setConstraint(){
        self.titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        todayView.snp.makeConstraints{
            $0.size.equalTo(30)
            $0.center.equalTo(contentView)
        }

        circleView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(44)
        }
    }
    
    func setViewWithData(day: Day){
        if day.date.isSameDay(as: Date()){
            todayView.backgroundColor = .challendarBlack100
        }
        circleView.backgroundColor = colorByPercentage(percentage: day.percentage)
    }
    
    private func colorByPercentage(percentage : Double) -> UIColor {
        switch percentage{
        case 0:
            return .clear
        case 0..<20:
            return .challendarGreen20
        case 20..<40:
            return .challendarGreen40
        case 40..<60:
            return .challendarGreen60
        case 60..<80:
            return .challendarGreen80
        case 80...:
            return .challendarGreen100
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
        todayView.backgroundColor = .clear
    }
    
}
