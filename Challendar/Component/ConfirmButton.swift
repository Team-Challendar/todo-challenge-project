//
//  ConfirmButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class ConfirmButton: UIButton {

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
        self.backgroundColor =  .challendarGreen100
        self.setTitleColor(.challendarBlack100, for: .normal)
    }
    
}
