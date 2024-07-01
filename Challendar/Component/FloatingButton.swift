//
//  FloatingButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

// 원 모양 FAB 버튼 Component
class FloatingButton: UIButton {
    var customView = UIView()
    var title = UILabel()
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = .challendarBlack
        setupShadow()
        setupBorder()
        customView.backgroundColor = .clear
        
        title.font = .pretendardRegular(size: 16)
        title.textColor = .challendarWhite
        title.text = "할 일 추가"
        
        image.image = .fab.withRenderingMode(.alwaysTemplate)
        image.tintColor = .challendarWhite
    
        [title, image].forEach{
            customView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        title.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-2)
            $0.top.bottom.equalToSuperview()
        }
        image.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(2)
            $0.size.equalTo(16)
            $0.centerY.equalToSuperview()
        }
        self.addSubview(customView)
        customView.snp.makeConstraints{
            $0.height.equalTo(24)
            $0.width.equalTo(92)
            $0.center.equalToSuperview()
        }
        customView.isUserInteractionEnabled = false
        
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

