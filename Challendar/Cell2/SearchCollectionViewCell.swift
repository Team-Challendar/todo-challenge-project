//
//  SearchCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 5/31/24.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var dateLabel: UILabel!
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
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 20)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .challendarGreen100
        dateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(dateLabel)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = .challendarGreen100
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
      
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            checkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
//
//    func formatDate(_ date: Date?) -> String {
//            guard let date = date else { return "날짜 없음" }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy. MM. dd"
//            return dateFormatter.string(from: date)
//        }
//    
//    func configure(with todo: TodoModel) {
//        titleLabel.text = todo.name
//        dateLabel.text = formatDate(todo.endDate)
//        checkButton.isSelected = todo.dailyCompletionStatus?.contains(true) ?? false
//    }
}
