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
    var stateLabel: UILabel!
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
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .challendarGreen100
        dateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarBlack60
        stateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(stateLabel)
        
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
            
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            dateLabel.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 4),
            
            checkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
      
    func configure(with item: Todo) {
        titleLabel.text = item.title
        dateLabel.text = formatDate(item.endDate)
        stateLabel.text = calculateState(startDate: item.startDate, endDate: item.endDate)
        contentView.backgroundColor = .challendarBlack80

        let progress = item.percentage
        if progress == 1.0 {
            checkButton.isSelected = true
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.textColor = .challendarBlack60
            dateLabel.alpha = 0.3
            stateLabel.alpha = 0.3
        } else {
            checkButton.isSelected = false
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: [:])
            dateLabel.alpha = 1.0
            stateLabel.alpha = 1.0
        }
    }

      private func formatDate(_ date: Date?) -> String {
          guard let date = date else { return "날짜 없음" }
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy. MM. dd"
          return dateFormatter.string(from: date)
      }
      
      private func calculateState(startDate: Date?, endDate: Date?) -> String {
          guard let startDate = startDate, let endDate = endDate else { return "날짜 없음" }
          let today = Date()
          
          if today > endDate {
              return "종료됨,"
          } else if today < startDate {
              return "내일부터,"
          } else if Calendar.current.isDateInToday(startDate) {
              return "오늘부터,"
          } else {
              return "진행 중,"
          }
      }
  }
// 체크 버튼 누를 시 셀 리로드.
