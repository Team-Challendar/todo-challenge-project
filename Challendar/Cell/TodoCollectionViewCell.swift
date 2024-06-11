//
//  TodoCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit


class TodoCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var checkButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .challendarBlack80
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 20)
        contentView.addSubview(titleLabel)

        
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.challendarBlack60, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
 
            checkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
      
//    func configure(with item: TodoModel) {
//        titleLabel.text = item.name
// 
//        contentView.backgroundColor = .challendarBlack80
//
//        if let progress = item.progress, progress == 1.0 {
//            checkButton.isSelected = true
//            titleLabel.attributedText = NSAttributedString(string: item.name, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
//            titleLabel.textColor = .challendarBlack60
//        
//        } else {
//            checkButton.isSelected = false
//            titleLabel.attributedText = NSAttributedString(string: item.name, attributes: [:])
//      
//        }
//    }
  }

