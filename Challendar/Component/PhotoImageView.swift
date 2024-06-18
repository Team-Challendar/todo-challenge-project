//
//  PhotoImageView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
// 사진 추가할 경우 Cell에 들어가는 UIImageView
class PhotoImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI(){
        self.layer.cornerRadius = photoCellCornerRadius
        self.layer.borderColor = UIColor.secondary600.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFill
    }

}
