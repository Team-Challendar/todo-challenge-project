//
//  editTitleLabel.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class EditTitleLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        setup(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(text: "")
    }
    
    private func setup(text: String) {
        self.text = text
        self.font = .pretendardSemiBold(size: 24)
        self.textColor = .challendarWhite100
        self.sizeToFit()
    }

}
