//
//  ChallengeCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SnapKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    var checkButton: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel: UILabel!
    var progressBar: UIProgressView!
    var todoItem: Todo? // Todo 항목을 저장할 속성
    
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
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .challendarBlack80
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .challendarWhite
        titleLabel.font = .pretendardMedium(size: 20)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .challendarBlack60
        dateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarGreen100
        stateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(stateLabel)
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .challendarGreen100
        progressBar.trackTintColor = .challendarBlack60
        contentView.addSubview(progressBar)
               
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.challendarBlack60, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            
            progressBar.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 4),
            progressBar.widthAnchor.constraint(equalToConstant: 24),
            progressBar.heightAnchor.constraint(equalToConstant: 6),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            dateLabel.leadingAnchor.constraint(equalTo: progressBar.trailingAnchor, constant: 4),
            
            checkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
        contentView.bringSubviewToFront(checkButton)
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
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
        progressBar.progress = Float(item.percentage)
        contentView.backgroundColor = .challendarBlack80

        // 오늘의 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.todayCompleted() ?? false
        updateTitleLabel()
    }
    
    private func updateTitleLabel() {
        if checkButton.isSelected {
            if let title = titleLabel.text {
                titleLabel.attributedText = title.strikeThrough()
                titleLabel.textColor = .challendarBlack60
            }
        } else {
            if let title = titleLabel.text {
                titleLabel.attributedText = NSAttributedString(string: title)
            }
            titleLabel.textColor = .challendarWhite
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "날짜 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter.string(from: date)
    }
    
    private func calculateState(startDate: Date?, endDate: Date?) -> String {
        guard let startDate = startDate, let endDate = endDate else { return "날짜 없음" }
        let today = Date()
        let calendar = Calendar.current
        
        if today > endDate {
            return "종료됨"
        } else if today < startDate {
            return "예정됨"
        }
        
        let components = calendar.dateComponents([.day], from: startDate, to: today)
        if let day = components.day {
            return "\(day + 1)일차"
        } else {
            return "날짜 없음"
        }
    }
    
    private func updateTodoCompletion(for item: Todo) {
        CoreDataManager.shared.updateTodoById(id: item.id ?? UUID(), newCompleted: item.completed)
    }
}
