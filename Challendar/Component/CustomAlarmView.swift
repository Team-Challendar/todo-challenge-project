//
//  AlarmPickerView.swift
//  Challendar
//
//  Created by Sam.Lee on 6/20/24.
//

import UIKit
import SnapKit

class CustomAlarmView : UIView{
    let pickerViewHour = PickerView()
    let pickerViewMinutes = PickerView()
    
    let hour = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    let minute = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    let multiplier = 1000
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI(){
        //View UI 구성
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .secondary850
        self.layer.borderColor = UIColor.secondary800.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        [pickerViewHour, pickerViewMinutes].forEach{
            $0.delegate = self
            $0.dataSource = self
            $0.selectionStyle = .overlay
            $0.scrollingStyle = .infinite
            $0.backgroundColor = .secondary850
            $0.selectionOverlay.backgroundColor = .secondary800
            $0.selectionOverlay.layer.cornerRadius = 4
            $0.selectionOverlay.layer.cornerCurve = .continuous
        }
        pickerViewHour.selectionOverlay.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        pickerViewMinutes.selectionOverlay.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        //        pickerViewHour.delegate = self
        //        pickerViewHour.dataSource = self
        //
        //        pickerViewMinutes.delegate = self
        //        pickerViewMinutes.dataSource = self
        //
        //        pickerViewHour.selectionStyle = .overlay
        //        pickerViewMinutes.selectionStyle = .overlay
        //
        //        pickerViewHour.scrollingStyle = .infinite
        //        pickerViewMinutes.scrollingStyle = .infinite
        //        // 서브뷰 수정
        
    }
    
    func configureConstraint(){
        self.addSubview(pickerViewHour)
        self.addSubview(pickerViewMinutes)
        pickerViewHour.translatesAutoresizingMaskIntoConstraints = false
        pickerViewMinutes.translatesAutoresizingMaskIntoConstraints = false
        
        pickerViewHour.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(5)
            $0.width.equalToSuperview().dividedBy(2)
            $0.leading.equalToSuperview().offset(12.5)
        }
        pickerViewMinutes.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(5)
            $0.width.equalToSuperview().dividedBy(2)
            $0.trailing.equalToSuperview().offset(-12.5)
        }
        
    }
    
    func configureUtil(){
        
    }
    
}

extension CustomAlarmView : PickerViewDelegate, PickerViewDataSource{
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        if pickerView == pickerViewHour {
            return hour.count
        }else{
            return minute.count
        }
    }
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 34
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        if pickerView == pickerViewHour {
            return hour[row]
        }else{
            return minute[row]
        }
        
    }
    
    func pickerView(_ pickerView: PickerView, viewForRow row: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
        var customView = view as? CustomPickerRowView
        
        if customView == nil {
            // Init your view
            customView = CustomPickerRowView()
            customView?.snp.makeConstraints {
                $0.height.equalTo(34)
                $0.width.equalTo(125.5)
            }
        }
        
        if pickerView == pickerViewHour {
            customView?.updateLabelConstraints(for: .hour)
            customView?.textLabel.text = hour[row]
        } else {
            customView?.updateLabelConstraints(for: .minute)
            customView?.textLabel.text = minute[row]
        }
        
        customView?.updateLabelStyle(highlighted: highlighted)
        
        return customView
    }
    
    //    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
    //        label.textAlignment = .center
    //
    //        if highlighted {
    //            label.font = UIFont.pretendardSemiBold(size: 28)
    //            label.textColor = .challendarWhite
    //        } else {
    //            label.font = UIFont.pretendardSemiBold(size: 20)
    //            label.textColor = .secondary700
    //        }
    //    }
}


