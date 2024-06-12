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
        self.backgroundColor = .secondary800
        self.setTitleColor(.secondary700, for: .normal)
    }
    func highLightState(){
        self.isEnabled = true
        self.backgroundColor = .challendarGreen200
        self.setTitleColor(.challendarBlack, for: .normal)
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    func laterState(){
        changeTitle(title: "나중에 정할래요")
        self.isEnabled = true
        self.setTitleColor(.challendarGreen200, for: .normal)
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.challendarGreen200.cgColor
        self.layer.borderWidth = 1
        self.titleLabel?.font = .pretendardMedium(size: 18)
    }
    
    func applyState(){
        self.isEnabled = true
        changeTitle(title: "적용하기")
        self.setTitleColor(.challendarBlack, for: .normal)
        self.backgroundColor = .challendarGreen200
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    
    func nonApplyState(){
        changeTitle(title: "적용하기")
        self.setTitleColor(.secondary800, for: .normal)
        self.backgroundColor = .secondary700
        self.titleLabel?.font = .pretendardMedium(size: 18)
    }
    
    func laterMediumState() {
        changeTitle(title: "나중에")
        self.layer.cornerRadius = 12
        self.isEnabled = true
        self.setTitleColor(.challendarGreen200, for: .normal)
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.challendarGreen200.cgColor
        self.layer.borderWidth = 1
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    
    func challengeState(){
        self.isEnabled = true
        self.layer.cornerRadius = 12
        changeTitle(title: "도전!")
        self.setTitleColor(.challendarBlack, for: .normal)
        self.backgroundColor = .challendarGreen200
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
}
