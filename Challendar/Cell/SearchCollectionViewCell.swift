//
//  SearchCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 5/31/24.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    var checkButton: UIButton!      // 체크버튼
    var titleLabel: UILabel!        // 투두 이름
    var dateLabel: UILabel!         // 종료 날짜
    var stateLabel: UILabel!        // 진행 여부
    var todoItem: Todo?             // Todo 항목을 저장할 속성
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.attributedText = nil
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .secondary850
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .challendarWhite
        titleLabel.font = .pretendardMedium(size: 18)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .secondary400
        dateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .primary200
        stateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(stateLabel)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.secondary800, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.primary200, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            
            dateLabel.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            
            checkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
        contentView.bringSubviewToFront(checkButton)
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        updateTitleLabel()
        
        guard let item = todoItem else { return }
        item.toggleTodaysCompletedState()
        updateTodoCompletion(for: item)
        
        print("Todo \(item.title) completed status updated: \(item.completed)")
    }
    
    func configure(with item: Todo) {
        self.todoItem = item
        titleLabel.text = item.title
        dateLabel.text = formatDate(item.endDate)
        stateLabel.text = calculateState(startDate: item.startDate, endDate: item.endDate)
        
        // 오늘의 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.todayCompleted() ?? false
        updateTitleLabel()
    }
    
    private func updateTitleLabel() {
        if checkButton.isSelected {
            if let title = titleLabel.text {
                titleLabel.attributedText = title.strikeThrough()
                titleLabel.textColor = .secondary800
                dateLabel.textColor = .secondary800
            }
        } else {
            if let title = titleLabel.text {
                titleLabel.attributedText = NSAttributedString(string: title)
            }
            titleLabel.textColor = .challendarWhite
            dateLabel.textColor = .secondary400
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return " " }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter.string(from: date)
    }
    
    private func calculateState(startDate: Date?, endDate: Date?) -> String {
        guard let startDate = startDate, let endDate = endDate else { return " " }
        let today = Date()
        let calendar = Calendar.current
        
        if today > endDate {
            return "종료됨"
        } else if today < startDate {
            let daysUntilStart = calendar.dateComponents([.day], from: today, to: startDate).day ?? 0
                return "\(daysUntilStart)일 후"
            } else if today == startDate {
            return "1일차"
        }
        
        let components = calendar.dateComponents([.day], from: startDate, to: today)
        if let day = components.day {
            return "\(day + 1)일차"
        } else {
            return " "
        }
    }
    
    private func updateTodoCompletion(for item: Todo) {
        CoreDataManager.shared.updateTodoById(id: item.id ?? UUID(), newCompleted: item.completed)
    }
}
