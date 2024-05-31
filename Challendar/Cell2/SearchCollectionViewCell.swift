//
//  SearchCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 5/31/24.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    var TitleLabel: UILabel!
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
        
        textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .gray
        textLabel.font = textLabel.font.withSize(14)
        contentView.addSubview(textLabel)
        
        TitleLabel = UILabel()
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.textColor = .white
        TitleLabel.font = TitleLabel.font.withSize(20)
        contentView.addSubview(TitleLabel)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = .challendarGreen100
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
      
        
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentView.heightAnchor.constraint(equalToConstant: 75),
            TitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            TitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
    
    func configure(with todo: TodoModel) {
        TitleLabel.text = todo.name
        checkButton.isSelected = todo.dailyCompletionStatus?.contains(true) ?? false
    }
}
