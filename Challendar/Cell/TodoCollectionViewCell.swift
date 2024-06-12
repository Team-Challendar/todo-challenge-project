//
//  TodoCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit
import Lottie

class TodoCollectionViewCell: UICollectionViewCell {
    let animation = LottieAnimation.named("doneTomato")
    var animationView : LottieAnimationView!
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
        configureUI()
        setupConstraints()
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondary850
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    private func configureUI(){
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 18)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.secondary800, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.alertTomato, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.backgroundColor = .secondary850
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        animationView = LottieAnimationView(animation: animation)
    }
    
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(animationView)
        contentView.addSubview(checkButton)
        
        titleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(checkButton.snp.leading).offset(12)
        }
        checkButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24).priority(999)
        }
        animationView.snp.makeConstraints{
            $0.center.equalTo(checkButton)
            $0.size.equalTo(96)
        }
    }
    
    @objc private func checkButtonTapped() {
        playBounceAnimation(checkButton)
        checkButton.isSelected.toggle()
        updateTitleLabel()
        animationView.play()
        
        guard let item = todoItem else { return }
        item.iscompleted.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.animationView.stop()
            self.updateTodoCompletion(for: item)
        })
    }
    
    func configure(with item: Todo) {
        self.todoItem = item
        titleLabel.text = item.title
        contentView.backgroundColor = .secondary850
        // 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.iscompleted
        updateTitleLabel()
    }
    
    private func updateTitleLabel() {
        if checkButton.isSelected {
            if let title = titleLabel.text {
                titleLabel.attributedText = title.strikeThrough()
                titleLabel.textColor = .secondary800
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
