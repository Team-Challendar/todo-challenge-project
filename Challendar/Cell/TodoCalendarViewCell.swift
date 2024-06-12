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
    var deleteButtonImage : UIImageView!
    var editContainer : UIView!
    var editButtonImage : UIImageView!
    var enrollChallengeContainer : UIView!
    private let buttonConfig = UIButton.Configuration.filled()
    private lazy var enrollChallengeButton = UIButton(configuration: buttonConfig)
    var swipeLeft : Bool = false
    var swipeRight : Bool = false

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
        contentView.backgroundColor = .secondary850
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        container = UIView()
        container.backgroundColor = .secondary850
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        
        deleteContainer = UIView()
        deleteContainer.backgroundColor = .alertRed
        deleteContainer.layer.cornerRadius = 20
        deleteContainer.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        deleteButtonImage = UIImageView()
        deleteButtonImage.image = UIImage(named: "trash")
        deleteButtonImage.backgroundColor = .clear
        deleteButtonImage.layer.cornerRadius = 20
        deleteButtonImage.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        editContainer = UIView()
        editContainer.backgroundColor = .alertOrange
        editButtonImage = UIImageView()
        editButtonImage.image = UIImage(named: "edit")
        editButtonImage.backgroundColor = .clear
        
        enrollChallengeContainer = UIView()
        enrollChallengeContainer.backgroundColor = .challendarGreen200
        enrollChallengeContainer.layer.cornerRadius = 20
        enrollChallengeContainer.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        enrollChallengeButton = UIButton()
        enrollChallengeButton.titleLabel?.font = .pretendardMedium(size: 20)
        enrollChallengeButton.setTitle("챌린지 등록하기", for: .normal)
        enrollChallengeButton.setTitleColor(.secondary900, for: .normal)
        
        enrollChallengeButton.setImage(UIImage(named: "challengeOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        enrollChallengeButton.configuration?.imagePadding = 4   // iOS 15.0 이상
        enrollChallengeButton.backgroundColor = .clear
        enrollChallengeButton.layer.cornerRadius = 20
        enrollChallengeButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        [enrollChallengeContainer, enrollChallengeButton, deleteContainer, deleteButtonImage, editContainer, editButtonImage, container].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .challendarWhite
        titleLabel.font = .pretendardMedium(size: 20)
        container.addSubview(titleLabel)
        container.bringSubviewToFront(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .secondary600
        dateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(dateLabel)
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarBlue600
        stateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(stateLabel)
               
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.secondary600, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarBlue600, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        container.addSubview(checkButton)
        animationView = LottieAnimationView(animation: animation)
        container.addSubview(animationView)
        container.bringSubviewToFront(checkButton)
        
        container.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        deleteContainer.snp.makeConstraints {
            $0.leading.equalTo(editContainer.snp.trailing).offset(-74)
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        deleteButtonImage.snp.makeConstraints {
            $0.leading.equalTo(deleteContainer.snp.leading).offset(25)
            $0.trailing.equalTo(deleteContainer.snp.trailing).offset(-25)
            $0.top.equalTo(deleteContainer.snp.top).offset(25.5)
            $0.bottom.equalTo(deleteContainer.snp.bottom).offset(-25.5)
        }
        
        editContainer.snp.makeConstraints {
            $0.leading.equalTo(container.snp.trailing).offset(-20)
            $0.trailing.equalTo(deleteContainer.snp.leading).offset(0)
            $0.top.bottom.equalToSuperview()
        }
        editButtonImage.snp.makeConstraints {
            $0.leading.equalTo(editContainer.snp.leading).offset(45)
            $0.trailing.equalTo(editContainer.snp.trailing).offset(-25)
            $0.top.equalTo(editContainer.snp.top).offset(25.5)
            $0.bottom.equalTo(editContainer.snp.bottom).offset(-25.5)
        }
        
        enrollChallengeContainer.snp.makeConstraints {
            $0.trailing.equalTo(container.snp.leading).offset(25)
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        enrollChallengeButton.snp.makeConstraints {
            $0.trailing.equalTo(container.snp.leading).offset(25)
            $0.leading.equalToSuperview()
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
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action:  #selector(didSwipeCellRight))
        swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)
        
        // 스와이프 버튼
        enrollTapGestureRecognizer()
        deleteTapGestureRecognizer()
        editTapGestureRecognizer()
    }
    
    @objc func didSwipeCellLeft() {
        UIView.animate(withDuration: 0.3) {
            if self.swipeRight == true {
                self.container.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                }
                self.swipeRight = false
            } else if self.swipeRight == false {
                self.container.snp.updateConstraints {
                    $0.trailing.equalToSuperview().offset(-148)
                    $0.leading.equalToSuperview().offset(-148)
                }
                self.swipeLeft = true
            }
            self.layoutIfNeeded()
        }
    }
    @objc func didSwipeCellRight() {
        UIView.animate(withDuration: 0.3) {
            if self.swipeLeft ==  true {
                self.container.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                }
                self.swipeLeft = false
            } else if self.swipeLeft == false {
                self.container.snp.updateConstraints {
                    $0.trailing.equalToSuperview().offset(185)
                    $0.leading.equalToSuperview().offset(185)
                }
                self.swipeRight = true
            }
            self.layoutIfNeeded()
        }
    }
    
    private func enrollTapGestureRecognizer() {
        enrollChallengeButton.addTarget(self, action: #selector(enrollButtonTapped), for: .touchUpInside)
    }
    @objc func enrollButtonTapped() {
        print("등록")
    }
    
    private func deleteTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteContainerTapped(_:)))
        deleteContainer.addGestureRecognizer(tapGesture)
        deleteContainer.isUserInteractionEnabled = true
    }
    @objc func deleteContainerTapped(_ sender: UITapGestureRecognizer) {
        print("delete")
        
    }
    
    private func editTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editContainerTapped(_:)))
        editContainer.addGestureRecognizer(tapGesture)
        editContainer.isUserInteractionEnabled = true
    }
    @objc func editContainerTapped(_ sender: UITapGestureRecognizer) {
        print("edit")
    }
    
    @objc private func checkButtonTapped() {
        playBounceAnimation(checkButton)
        animationView.play()
        checkButton.isSelected.toggle()
        updateTitleLabel()
        guard let item = todoItem else { return }
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
        contentView.backgroundColor = .secondary800
        // 오늘의 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.todayCompleted(date: date) ?? false
        updateTitleLabel()
    }
    
    private func updateTitleLabel() {
        if checkButton.isSelected {
            if let title = titleLabel.text {
                titleLabel.attributedText = title.strikeThrough()
                titleLabel.textColor = .secondary600
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
