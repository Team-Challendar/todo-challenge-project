//
//  CalendarCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/1/24.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarCell: FSCalendarCell {
    static var identifier = "CalendarCell"
    var circleView = UIView()
    var leftView = UIView()
    var rightView = UIView()
    var todayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
        
    }
    
    func setView(){
        circleView.layer.cornerRadius = CGFloat(calendarCircleSize) / 2
        circleView.clipsToBounds = true
        todayView.layer.cornerRadius = 4 / 2
        todayView.layer.cornerCurve = .continuous
        todayView.clipsToBounds = true
        [todayView, circleView, leftView, rightView].forEach{
            contentView.insertSubview($0, at: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        todayView.backgroundColor = .challendarBlack100
        circleView.backgroundColor = .challendarGreen100
        leftView.backgroundColor = .challendarGreen80
        rightView.backgroundColor = .challendarGreen80
        self.titleLabel.textAlignment = .center
    }
    
    func setConstraint(){
        self.titleLabel.snp.makeConstraints {             
            $0.center.equalTo(contentView)
        }
        todayView.snp.makeConstraints{
            $0.size.equalTo(4)
            $0.top.equalTo(circleView.snp.top).offset(3)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        leftView.snp.makeConstraints {
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView.snp.centerX)
            $0.height.equalTo(calendarCircleSize)
            $0.centerY.equalTo(contentView)
        }

        circleView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(calendarCircleSize)
        }

        rightView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.centerX)
            $0.trailing.equalTo(contentView)
            $0.height.equalTo(calendarCircleSize)
            $0.centerY.equalTo(contentView)
        }
    }
    func updateBackImage(_ dateType: SelectedDateType) {
        titleLabel.textColor = .challendarBlack100
        todayView.isHidden = true
            switch dateType {
            case .singleDate:
                leftView.isHidden = true
                rightView.isHidden = true
                circleView.isHidden = false
            case .firstDate:
                leftView.isHidden = true
                circleView.isHidden = false
                rightView.isHidden = false
            case .middleDate:
                circleView.isHidden = true
                leftView.isHidden = false
                rightView.isHidden = false
            case .lastDate:
                rightView.isHidden = true
                circleView.isHidden = false
                leftView.isHidden = false
            case .notSelected:
                circleView.isHidden = true
                leftView.isHidden = true
                rightView.isHidden = true
            }
        }
    
    func updateToday(_ dateType: SelectedDateType){
        
        if dateType == .notSelected {
            todayView.isHidden = false
            todayView.backgroundColor = .systemRed
            self.titleLabel.backgroundColor = .clear
            self.titleLabel.textColor = .challendarWhite100
        }else{
            todayView.isHidden = false
            todayView.backgroundColor = .challendarBlack100
            self.titleLabel.backgroundColor = .clear
            self.titleLabel.textColor = .challendarBlack100
        }
        
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleView.backgroundColor = .challendarGreen100
    }
    
}
