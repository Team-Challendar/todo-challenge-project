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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
        
    }
    
    func setView(){
        circleView.layer.cornerRadius = 30 / 2
        circleView.clipsToBounds = true
        
        [circleView, leftView, rightView].forEach{
            contentView.insertSubview($0, at: 0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .challendarGreen100
        }
        self.titleLabel.textAlignment = .center
    }
    
    func setConstraint(){
        self.titleLabel.snp.makeConstraints {             
            $0.center.equalTo(contentView)
        }
        
        leftView.snp.makeConstraints {
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView.snp.centerX)
            $0.height.equalTo(30)
            $0.centerY.equalTo(contentView)
        }

        circleView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.size.equalTo(30)
        }

        rightView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.centerX)
            $0.trailing.equalTo(contentView)
            $0.height.equalTo(30)
            $0.centerY.equalTo(contentView)
        }
    }
    func updateBackImage(_ dateType: SelectedDateType) {
            switch dateType {
            case .singleDate:
                // left right hidden true
                // circle hidden false
                leftView.isHidden = true
                rightView.isHidden = true
                circleView.isHidden = false

            case .firstDate:
                // leftRect hidden true
                // circle, right hidden false
                leftView.isHidden = true
                circleView.isHidden = false
                rightView.isHidden = false

            case .middleDate:
                // circle hidden true
                // left, right hidden false
                circleView.isHidden = true
                leftView.isHidden = false
                rightView.isHidden = false

            case .lastDate:
                // rightRect hidden true
                // circle, left hidden false
                rightView.isHidden = true
                circleView.isHidden = false
                leftView.isHidden = false
            case .notSelectd:
                // all hidden
                circleView.isHidden = true
                leftView.isHidden = true
                rightView.isHidden = true
            }

        }
    
    func selectedState(){
        self.circleView.backgroundColor = .challendarGreen100
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .challendarBlack100
    }
    func deSelectedState(){
        self.circleView.backgroundColor = .clear
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .challendarWhite100
    }
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
