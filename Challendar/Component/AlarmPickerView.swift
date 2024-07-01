//
//  AlarmPickerView.swift
//  Challendar
//
//  Created by Sam.Lee on 6/20/24.
//

import UIKit
import SnapKit

protocol AlarmPickerViewDelegate {
    func timeDidChanged(date: Date)
}
class AlarmPickerView : UIView{
    let pickerView = UIDatePicker()
    var delegate : AlarmPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
        configureUtil()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI(){
        //View UI 구성
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.secondary800.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = Locale(identifier: "en_GB")
        pickerView.minuteInterval = 5
        // 서브뷰 수정
        
    }
    
    func configureConstraint(){
        self.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
    
    func configureUtil(){
        pickerView.addTarget(self, action: #selector(pickerViewChanged(datePicker:)), for: .valueChanged)
    }
    
    @objc func pickerViewChanged(datePicker : UIDatePicker){
        print(datePicker.date.dateToString())
        self.delegate?.timeDidChanged(date: datePicker.date)
    }

}
