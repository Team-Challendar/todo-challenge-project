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
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        // 기본 구성
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .challendarBlack
        config.baseForegroundColor = .challendarWhite
        config.cornerStyle = .capsule
        
        // 타이틀과 이미지 설정
        config.title = "할 일 추가"
        titleLabel?.font = .pretendardRegular(size: 16)
        titleLabel?.textColor = .challendarWhite
        config.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        
        // 타이틀과 이미지 간격 설정
        config.imagePadding = 4 // 이미지와 타이틀 간격
        config.imagePlacement = .leading
        
        // 구성 적용
        self.configuration = config
        
        // 그림자 및 보더 설정
        setupShadow()
        setupBorder()
        
        // 이미지 크기 조정
        if let imageView = self.imageView {
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 14),
                imageView.heightAnchor.constraint(equalToConstant: 14),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16), // 이미지와 왼쪽 간격 설정
                self.titleLabel!.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4) // 이미지와 타이틀 간격 설정
            ])
        }
    }

    
    private func setupShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondary800.cgColor
        self.layer.cornerRadius = 26
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 128, height: 52)
    }
}

