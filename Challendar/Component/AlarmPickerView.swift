//
//  AlarmPickerView.swift
//  Challendar
//
//  Created by Sam.Lee on 6/20/24.
//

import UIKit
import SnapKit

class AlarmPickerView : UIView{
    let pickerView = UIPickerView()
    
    let hour = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.printSubviews(of: pickerView, level: 0)
        
        pickerView.subviews[1].backgroundColor = .secondary800.withAlphaComponent(0.5)
        pickerView.subviews[1].layer.cornerRadius = 4
        
        
    }
}

extension AlarmPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hour.count * multiplier
        }else{
            return minute.count * multiplier
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let componentView = UIView()
        let label = UILabel()
        
        componentView.addSubview(label)
        [componentView,label].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        componentView.snp.makeConstraints{
            $0.width.equalTo(149.5)
            $0.height.equalTo(34)
        }
        if component == 0 {
            label.text = hour[row % hour.count]
            label.snp.makeConstraints{
                $0.trailing.equalTo(componentView.snp.trailing).offset(-12)
                $0.height.equalTo(componentView)
            }
        }else{
            label.text = minute[row % minute.count]
            label.snp.makeConstraints{
                $0.trailing.equalToSuperview()
                $0.leading.equalToSuperview().offset(12)
                $0.height.equalTo(componentView)
            }
        }
        label.textColor = .white
        label.font = .pretendardSemiBold(size: 28)
        
        
        return componentView
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let middleRow = (multiplier / 2) * hour.count + (row % hour.count)
            pickerView.selectRow(middleRow, inComponent: component, animated: false)
        } else {
            let middleRow = (multiplier / 2) * minute.count + (row % minute.count)
            pickerView.selectRow(middleRow, inComponent: component, animated: false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.width / 2
    }
}
