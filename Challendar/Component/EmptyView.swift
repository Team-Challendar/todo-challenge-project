//
//  EmptyView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class EmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        self.backgroundColor = .secondary850
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}
