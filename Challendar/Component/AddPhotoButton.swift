//
//  AddPhotoButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
// 사진 추가 버튼 UIButton
class AddPhotoButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setup()
    }
    
    func setup(count : Int = 0) {
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.foregroundColor = UIColor.secondary700
        titleContainer.font = .pretendardMedium(size: 13)
        configuration.attributedTitle = AttributedString("\(count)/5", attributes: titleContainer)
        configuration.image = UIImage.camera.withTintColor(.secondary700, renderingMode: .alwaysOriginal)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 17)
        configuration.imagePadding = 5
        
        configuration.imagePlacement = .top
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)
        configuration.baseBackgroundColor = .clear
        self.configuration = configuration
    }
    
    private func setupUI(){
        self.layer.cornerRadius = photoCellCornerRadius
        self.layer.borderColor = UIColor.secondary700.cgColor
        self.layer.borderWidth = 1
    }
    
    

}
