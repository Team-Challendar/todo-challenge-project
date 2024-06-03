//
//  ConfirmButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.setTitle("다음", for: .normal)
        self.titleLabel?.font = .pretendardMedium(size: 18)
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        normalState()
    }
    
    func changeTitle(title: String){
        self.setTitle(title, for: .normal)
    }
    
    func normalState(){
        self.isEnabled = false
        self.backgroundColor = .challendarButtonNormal
        self.setTitleColor(.challendarPlaceHolder, for: .normal)
    }
    func highLightState(){
        self.isEnabled = true
        self.backgroundColor = .challendarGreen100
        self.setTitleColor(.challendarBlack100, for: .normal)
    }
    func laterState(){
        changeTitle(title: "나중에 정할래요")
        self.setTitleColor(.challendarGreen100, for: .normal)
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.challendarGreen100.cgColor
        self.layer.borderWidth = 1
    }
    
    func applyState(){
        changeTitle(title: "적용하기")
        self.setTitleColor(.challendarBlack100, for: .normal)
        self.backgroundColor = .challendarGreen100
    }
    
    func nonApplyState(){
        changeTitle(title: "적용하기")
        self.setTitleColor(.challendarNonApply, for: .normal)
        self.backgroundColor = .challendarNonApplyBackground
    }
}
