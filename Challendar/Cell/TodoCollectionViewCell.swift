//
//  TodoCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit
import Lottie

protocol TodoViewCellDelegate: AnyObject {
    func editContainerTapped(in cell: TodoCollectionViewCell)
}

class TodoCollectionViewCell: UICollectionViewCell {
    static var identifier = "TodoCollectionViewCell"
    let animation = LottieAnimation.named("doneTomato")
    var animationView : LottieAnimationView!
    var titleLabel: UILabel!
    var checkButton: UIButton!
    private var container : UIView!
    private var deleteContainer : UIView!
    private var deleteButtonImage : UIImageView!
    private var editContainer : UIView!
    private var editButtonImage : UIImageView!
    private var swipeLeft : Bool = false
    private var swipeRight : Bool = false
    weak var delegate: TodoViewCellDelegate?
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
        swipeLeft = false
        swipeRight = false
        self.container.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
        [deleteContainer, deleteButtonImage, editContainer, editButtonImage].forEach{
            $0?.isHidden = true
        }
    }
    
    private func setupViews() {
        setupContentView()
        configureUI()
        setupConstraints()
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
//        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .secondary850
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(75)
        }
    }
    
    private func configureUI(){
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
        
        [deleteContainer, deleteButtonImage, editContainer, editButtonImage, container].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [deleteContainer, deleteButtonImage, editContainer, editButtonImage].forEach{
            $0?.isHidden = true
        }
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 18)
        container.addSubview(titleLabel)
        container.bringSubviewToFront(titleLabel)
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.secondary800, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.alertTomato, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.backgroundColor = .secondary850
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        container.addSubview(checkButton)
        animationView = LottieAnimationView(animation: animation)
        container.addSubview(animationView)
        container.bringSubviewToFront(checkButton)
    }
    
    func rightContainerHiddenToggle(){
        [deleteContainer, deleteButtonImage, editContainer, editButtonImage].forEach{
            $0?.isHidden.toggle()
        }
    }
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(animationView)
        contentView.addSubview(checkButton)
        
        container.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(0)
        }
        editContainer.snp.makeConstraints {
            $0.leading.equalTo(container.snp.trailing).offset(-20)
            $0.trailing.equalTo(deleteContainer.snp.leading).offset(0)
            $0.top.bottom.equalToSuperview()
        }
        
        deleteContainer.snp.makeConstraints {
            $0.leading.equalTo(editContainer.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(75)
        }
        deleteButtonImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(deleteContainer.snp.trailing).offset(-25)
            $0.centerY.equalTo(deleteContainer)
        }
        
        editButtonImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(editContainer.snp.trailing).offset(-25)
            $0.centerY.equalTo(editContainer)
        }
        titleLabel.snp.makeConstraints{
            $0.centerY.equalTo(container)
            $0.leading.equalTo(container.snp.leading).offset(24)
            $0.trailing.equalTo(checkButton.snp.leading).offset(5)
        }
        checkButton.snp.makeConstraints{
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(container.snp.trailing).offset(-24)
            $0.size.equalTo(24)
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
        deleteTapGestureRecognizer()
        editTapGestureRecognizer()
    }
    
    @objc func didSwipeCellLeft() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.swipeRight == true {
                self.container.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                }
                self.swipeRight = false
            } else if self.swipeRight == false {
                self.rightContainerHiddenToggle()
                self.container.snp.updateConstraints {
                    $0.trailing.equalToSuperview().offset(-148)
                    $0.leading.equalToSuperview().offset(-148)
                }
                self.swipeLeft = true
            }
            self.layoutIfNeeded()
        },completion: { _ in
            
        })
    }
    @objc func didSwipeCellRight() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.swipeLeft ==  true {
                self.container.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                }
            } else if self.swipeLeft == false {
                self.swipeRight = true
            }
            self.layoutIfNeeded()
        },completion: { _ in
            if self.swipeLeft == true {
                self.rightContainerHiddenToggle()
                self.swipeLeft = false
            }
        })
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
        self.rightContainerHiddenToggle()
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
        self.rightContainerHiddenToggle()
        self.swipeLeft = false
    }
    
    @objc private func checkButtonTapped() {
        if self.swipeLeft {
            self.didSwipeCellRight()
        }else{
            guard let item = todoItem else { return }
            if item.iscompleted {
                item.iscompleted.toggle()
                checkButton.isSelected.toggle()
                updateTitleLabel()
                self.updateTodoCompletion(for: item)
            }else{
                contentView.clipsToBounds = false
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.didSwipeCellLeft()
                    self.didSwipeCellRight()
                    self.playBounceAnimation(self.checkButton)
                    self.animationView.play()
                })
                checkButton.isSelected.toggle()
                updateTitleLabel()
                
                guard let item = todoItem else { return }
                item.iscompleted.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    self.animationView.stop()
                    self.contentView.clipsToBounds = true
                    self.updateTodoCompletion(for: item)
                })
            }
        }
       
            
        
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
