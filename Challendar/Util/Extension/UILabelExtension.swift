//
//  UILabelExtension.swift
//  Challendar
//
//  Created by Sam.Lee on 6/7/24.
//

import UIKit

extension UILabel {
    func adjustTextPosition(top: CGFloat, right: CGFloat) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        
        let attributedText = NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .baselineOffset: top,
            .kern: right
        ])
        
        self.attributedText = attributedText
    }
}
