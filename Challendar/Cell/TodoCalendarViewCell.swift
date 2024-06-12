//
//  ChallengeCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SnapKit
import Lottie

class TodoCalendarViewCell: UICollectionViewCell {
    static var identifier = "TodoCalendarViewCell"
    let animation = LottieAnimation.named("checkBoxAnimation2")
    var animationView : LottieAnimationView!
    var checkButton: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel : UILabel!
    var container : UIView!
    var deleteContainer : UIView!
    
    var todoItem: Todo? // Todo 항목을 저장할 속성
    var currentDate : Date?
    
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
        contentView.clipsToBounds = true
        contentView.backgroundColor = .challendarBlack80
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        container = UIView()
        container.backgroundColor = .challendarBlack80
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        deleteContainer = UIView()
        deleteContainer.backgroundColor = .red
        [deleteContainer,container].forEach{
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .challendarWhite
        titleLabel.font = .pretendardMedium(size: 20)
        container.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .challendarBlack60
        dateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarBlue600
        stateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(stateLabel)
               
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.challendarBlack60, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarBlue600, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        container.addSubview(checkButton)
        animationView = LottieAnimationView(animation: animation)
        container.addSubview(animationView)
        container.bringSubviewToFront(checkButton)
        
        
        container.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        deleteContainer.snp.makeConstraints{
            $0.leading.equalTo(container.snp.trailing).offset(-20)
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top).offset(16.5)
            make.leading.equalTo(container.snp.leading).offset(24)
        }

        stateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(container.snp.bottom).offset(-16.5)
            make.leading.equalTo(container.snp.leading).offset(24)
        }

        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(container.snp.bottom).offset(-16.5)
            make.leading.equalTo(stateLabel.snp.trailing).offset(4)
        }

        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(container.snp.trailing).offset(-24)
        }
        
        animationView.snp.makeConstraints{
            $0.center.equalTo(checkButton)
            $0.size.equalTo(96)
        }
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellLeft))
        swipeGestureLeft.direction = .left
        self.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellRight))
        swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)
        
    }
    @objc func didSwipeCellLeft(){
        UIView.animate(withDuration: 0.3) {
            self.container.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-50)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func didSwipeCellRight(){
        UIView.animate(withDuration: 0.3) {
            self.container.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc private func checkButtonTapped() {
        playBounceAnimation(checkButton)
        animationView.play()
        checkButton.isSelected.toggle()
        updateTitleLabel()
        guard let item = todoItem else { return }
//        print(self.currentDate?.dateToString())
        item.toggleDatesCompletedState(date: self.currentDate!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animationView.stop()
            self.updateTodoCompletion(for: item)
            
        })
        // Notification으로 챌린지 리스트 뷰에 변경됨을 알림
    }
    
    func configure(with item: Todo, date: Date) {
        self.todoItem = item
        titleLabel.text = item.title
        dateLabel.text = formatDate(item.endDate)
        stateLabel.text = calculateState(startDate: item.startDate, endDate: item.endDate)
        self.currentDate = date
        contentView.backgroundColor = .challendarBlack80
        // 오늘의 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.todayCompleted(date: date) ?? false
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
    
    func playBounceAnimation(_ icon : UIButton) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.8, 1.1, 1.0]
        bounceAnimation.duration = 0.2
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}
