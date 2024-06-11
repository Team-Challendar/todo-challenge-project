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
    var todoItem: Todo?
    
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
        setupContentView()
        setupTitleLabel()
        setupCheckButton()
        setupConstraints()
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .challendarBlack80
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 20)
        contentView.addSubview(titleLabel)
    }
    
    private func setupCheckButton() {
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.challendarBlack60, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        updateTitleLabel()
        
        guard let item = todoItem else { return }
        item.iscompleted.toggle()
        updateTodoCompletion(for: item)
        
        print("Todo \(item.title) completed status updated: \(item.iscompleted)")
    }
    
    func configure(with item: Todo) {
        self.todoItem = item
        titleLabel.text = item.title
        contentView.backgroundColor = .challendarBlack80
        
        // 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.iscompleted
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
    
    private func updateTodoCompletion(for item: Todo) {
        CoreDataManager.shared.updateTodoById(id: item.id ?? UUID(), newCompleted: item.completed, newIsCompleted: item.iscompleted)
    }
}
