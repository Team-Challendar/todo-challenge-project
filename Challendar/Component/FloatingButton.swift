//
//  FloatingButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class FloatingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .challendarBlack100
        self.setImage(.fabType01.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .normal)
        self.layer.cornerRadius = 60 / 2
        self.layer.borderColor = UIColor.challendarBlack60.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        setupShadow()
    }
    
    private func setupShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45).cgColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
}
