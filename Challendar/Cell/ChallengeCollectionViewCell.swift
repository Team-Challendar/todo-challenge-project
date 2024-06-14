//
//  ChallengeCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SnapKit
import Lottie

protocol ChallengeCollectionViewCellDelegate: AnyObject {
    func editContainerTapped(in cell: ChallengeCollectionViewCell)
}

class ChallengeCollectionViewCell: UICollectionViewCell {
    let animation = LottieAnimation.named("doneGreen")
    var animationView : LottieAnimationView!
    var checkButton: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel: UILabel!
    var progressBar: UIProgressView!
    private var container : UIView!
    private var deleteContainer : UIView!
    private var deleteButtonImage : UIImageView!
    private var editContainer : UIView!
    private var editButtonImage : UIImageView!
    private var enrollChallengeContainer : UIView!
    private let buttonConfig = UIButton.Configuration.filled()
    private lazy var enrollChallengeButton = UIButton(configuration: buttonConfig)
    private var swipeLeft : Bool = false
    private var swipeRight : Bool = false
    weak var delegate: ChallengeCollectionViewCellDelegate?
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
//        super.prepareForReuse()
        titleLabel.attributedText = nil
        deleteContainer = nil
        editContainer = nil
        enrollChallengeContainer = nil
        deleteButtonImage = nil
        editButtonImage = nil
        enrollChallengeButton = UIButton()
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
        enrollChallengeContainer.backgroundColor = .challendarBlue600
        enrollChallengeContainer.layer.cornerRadius = 20
        enrollChallengeContainer.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        enrollChallengeButton = UIButton()
        enrollChallengeButton.titleLabel?.font = .pretendardMedium(size: 20)
        enrollChallengeButton.setTitle("계획으로 옮기기", for: .normal)
        enrollChallengeButton.setTitleColor(.secondary900, for: .normal)
        
        enrollChallengeButton.setImage(UIImage(named: "Calendar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
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
        titleLabel.font = .pretendardMedium(size: 18)
        container.addSubview(titleLabel)
        container.bringSubviewToFront(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .secondary400
        dateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarGreen200
        stateLabel.font = .pretendardMedium(size: 12)
        container.addSubview(stateLabel)
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .challendarGreen200
        progressBar.trackTintColor = .secondary800
        container.addSubview(progressBar)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.secondary800, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarGreen200, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.backgroundColor = .secondary850
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
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(container.snp.top).offset(18)
            $0.leading.equalTo(container.snp.leading).offset(24)
        }

        stateLabel.snp.makeConstraints {
            $0.leading.equalTo(container.snp.leading).offset(24)
            $0.bottom.equalTo(container.snp.bottom).offset(-16.5)
        }

        progressBar.snp.makeConstraints {
            $0.centerY.equalTo(stateLabel.snp.centerY)
            $0.leading.equalTo(stateLabel.snp.trailing).offset(4)
            $0.width.equalTo(24)
            $0.height.equalTo(6)
        }

        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(container.snp.bottom).offset(-16.5)
            $0.leading.equalTo(progressBar.snp.trailing).offset(4)
        }

        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(container.snp.trailing).offset(-24)
        }

        animationView.snp.makeConstraints{
            $0.center.equalTo(checkButton)
            $0.size.equalTo(96)
        }
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
        
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
        guard let item = todoItem else { return }
        item.isChallenge = false
        self.enrollChallenge(for: item)
        self.container.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
        self.swipeLeft = false
    }
    private func enrollChallenge(for item: Todo) {
        CoreDataManager.shared.updateTodoById(id: item.id ?? UUID(), newIsChallenge: item.isChallenge)
    }
    
    private func deleteTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteContainerTapped(_:)))
        deleteContainer.addGestureRecognizer(tapGesture)
        deleteContainer.isUserInteractionEnabled = true
    }
    @objc func deleteContainerTapped(_ sender: UITapGestureRecognizer) {
        guard let item = todoItem else { return }
        self.deleteTodo(for: item)
        self.container.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
        self.swipeLeft = false
    }
    private func deleteTodo(for item: Todo) {
        CoreDataManager.shared.deleteTodoById(id: item.id ?? UUID())
    }
    
    private func editTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editContainerTapped(_:)))
        editContainer.addGestureRecognizer(tapGesture)
        editContainer.isUserInteractionEnabled = true
    }
    @objc func editContainerTapped(_ sender: UITapGestureRecognizer) {
        delegate?.editContainerTapped(in: self)
        self.container.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
        self.swipeLeft = false
    }
    
    @objc private func checkButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.didSwipeCellLeft()
            self.didSwipeCellRight()
            self.playBounceAnimation(self.checkButton)
            self.animationView.play()
        })
        checkButton.isSelected.toggle()
        updateTitleLabel()
        
        guard let item = todoItem else { return }
        item.toggleTodaysCompletedState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.animationView.stop()
            self.updatePercentage(for: item)
            self.updateTodoCompletion(for: item)
        })
        
    }
    
    func configure(with item: Todo) {
        self.todoItem = item
        titleLabel.text = item.title
        dateLabel.text = formatDate(item.endDate)
        stateLabel.text = calculateState(startDate: item.startDate, endDate: item.endDate)
        updatePercentage(for: item) // Update percentage when configuring
        progressBar.progress = Float(item.percentage)
        
        // 오늘의 완료 여부에 따라 체크 버튼 상태 설정
        checkButton.isSelected = item.todayCompleted() ?? false
        updateTitleLabel()
    }
    
    // 퍼센티지 계산 로직 추가 
    private func updatePercentage(for item: Todo) {
        let completedCount = item.completed.filter { $0 }.count
        item.percentage = Double(completedCount) / Double(item.completed.count)
        
        print("Todo \(item.title) completed status updated: \(item.percentage)")
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
        NotificationCenter.default.post(name: NSNotification.Name("ButtonTapped"), object: nil, userInfo: nil)
    }
}
