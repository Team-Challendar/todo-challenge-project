//
//  AddTodoBottomSheetViewController.swift
//  Challendar
//
//  Created by 서혜림 on 6/19/24.
//

import UIKit
import SnapKit
import FSCalendar

class AddTodoBottomSheetViewController: UIViewController {
    var dimmedView = UIView()
    var bottomSheetView = UIView()
    
    var contentStackView = UIStackView()
    var editTitleView = UIView()
    var todoImageView = UIImageView()
    var titleTextField = UITextField()
    var bottomLine = UIView()
    
    var todoDateRangeView = UIView()
    var dateImageView = UIImageView()
    var startDateLabel = UILabel()
    var arrowLabel = UILabel()
    var endDateLabel = UILabel()
    var calendarContainerView = NewCalendarView()
    
    var alertView = UIView()
    var alertImageView = UIImageView()
    var alertLabel = UILabel()
    var alertPickerView = AlarmPickerView()
    
    var repetitionView = UIView()
    var repetitionImageView = UIImageView()
    var repetitionLabel = UILabel()
    var repetitionCollectionView = RepetitionCollectionView()
    var selectedRepetitionDates: [Int] = []
    
    var challengeCheckView = UIView()
    var challengeCheckImageView = UIImageView()
    var challengeCheckLabel = UILabel()
    
    var registerButton = UIButton()
    var dismissCompletion: (() -> Void)?
    
    var newTodo = Todo() {
        didSet {
            updateUI()
        }
    }
    
    private var bottomSheetInitialConstraint: Constraint?
    private var bottomSheetKeyboardConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        configureUI()
        configureConstraints()
        configureGestures()
        configureKeyboardObservers()
        showBottomSheet()
    }
    
    private func configureUI() {
        [dimmedView, bottomSheetView, contentStackView, editTitleView, todoImageView, titleTextField, bottomLine, todoDateRangeView, dateImageView, calendarContainerView, alertView, alertImageView, alertLabel, alertPickerView, repetitionView, repetitionImageView, repetitionLabel, repetitionCollectionView, challengeCheckView, challengeCheckImageView, challengeCheckLabel, registerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        // Dimmed view 설정
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(dimmedView)
        
        // Bottom sheet view 설정
        bottomSheetView.backgroundColor = .secondary850
        bottomSheetView.layer.cornerRadius = 20
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(bottomSheetView)
        
        // contentStackView 설정
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.backgroundColor = .clear
        bottomSheetView.addSubview(contentStackView)
        
        // editTitleView 설정
        editTitleView.backgroundColor = .clear
        contentStackView.addArrangedSubview(editTitleView)
        
        // todoImageView 설정
        todoImageView.backgroundColor = .clear
        todoImageView.image = .done3.withTintColor(.alertTomato)
        editTitleView.addSubview(todoImageView)
        
        // titleTextField 설정
        titleTextField.backgroundColor = .clear
        titleTextField.font = .pretendardMedium(size: 20)
        titleTextField.textColor = .challendarWhite
        titleTextField.tintColor = .alertTomato
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "할 일을 입력해주세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        editTitleView.addSubview(titleTextField)
        
        // bottomLine 설정
        bottomLine.backgroundColor = .secondary800
        contentStackView.addArrangedSubview(bottomLine)
        
        // todoDateRangeView 설정
        todoDateRangeView.backgroundColor = .clear
        contentStackView.addArrangedSubview(todoDateRangeView)
        
        dateImageView.backgroundColor = .clear
        dateImageView.image = .clock1.withTintColor(.secondary600)
        todoDateRangeView.addSubview(dateImageView)
        
        startDateLabel.font = .pretendardMedium(size: 16)
        startDateLabel.textColor = .secondary600
        startDateLabel.text = "기한 없음"
        todoDateRangeView.addSubview(startDateLabel)
        
        arrowLabel.font = .pretendardMedium(size: 16)
        arrowLabel.textColor = .secondary700
        arrowLabel.text = "->"
        arrowLabel.isHidden = true
        todoDateRangeView.addSubview(arrowLabel)
        
        endDateLabel.font = .pretendardMedium(size: 16)
        endDateLabel.textColor = .secondary600
        endDateLabel.isHidden = true
        todoDateRangeView.addSubview(endDateLabel)
        
        calendarContainerView.backgroundColor = .clear
        calendarContainerView.isHidden = true
        calendarContainerView.delegate = self
        contentStackView.addArrangedSubview(calendarContainerView)
        
        // alertView 설정
        alertView.backgroundColor = .clear
        alertView.isHidden = true
        contentStackView.addArrangedSubview(alertView)
        
        alertImageView.backgroundColor = .clear
        alertImageView.image = .notification1.withTintColor(.secondary600)
        alertView.addSubview(alertImageView)
        
        alertLabel.text = "알림 없음"
        alertLabel.textColor = .secondary600
        alertLabel.font = .pretendardMedium(size: 16)
        alertView.addSubview(alertLabel)
        
        alertPickerView.backgroundColor = .clear
        alertPickerView.isHidden = true
        contentStackView.addArrangedSubview(alertPickerView)
        
        // repetitionView 설정
        repetitionView.backgroundColor = .clear
        repetitionView.isHidden = true
        contentStackView.addArrangedSubview(repetitionView)
        
        repetitionImageView.backgroundColor = .clear
        repetitionImageView.image = .re1.withTintColor(.secondary600)
        repetitionView.addSubview(repetitionImageView)
        
        repetitionLabel.text = "반복 안 함"
        repetitionLabel.textColor = .secondary600
        repetitionLabel.font = .pretendardMedium(size: 16)
        repetitionView.addSubview(repetitionLabel)
        
        repetitionCollectionView.items = ["매일", "월", "화", "수", "목", "금", "토", "일"]
        repetitionCollectionView.isHidden = true
        repetitionCollectionView.delegate = self
        repetitionView.addSubview(repetitionCollectionView)
        
        // challengeCheckView 설정
        challengeCheckView.backgroundColor = .clear
        challengeCheckView.isHidden = true
        contentStackView.addArrangedSubview(challengeCheckView)
        
        challengeCheckImageView.backgroundColor = .clear
        challengeCheckImageView.image = .challengeCheck1.withTintColor(.secondary600)
        challengeCheckView.addSubview(challengeCheckImageView)
        
        challengeCheckLabel.text = "챌린지 안 함"
        challengeCheckLabel.textColor = .secondary600
        challengeCheckLabel.font = .pretendardMedium(size: 16)
        challengeCheckView.addSubview(challengeCheckLabel)
        
        // registerButton 설정
        registerButton.setTitle("할 일 추가하기", for: .normal)
        registerButton.titleLabel?.font = .pretendardSemiBold(size: 18)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .alertTomato
        registerButton.layer.cornerRadius = 20
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        bottomSheetView.addSubview(registerButton)
    }
    
    private func configureConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.bottomSheetInitialConstraint = make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).constraint
            self.bottomSheetKeyboardConstraint = make.bottom.equalToSuperview().constraint
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(registerButton.snp.top).offset(-24)
        }
        
        // editTitleView 제약조건
        editTitleView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        // todoImageView 제약조건
        todoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.leading.equalTo(editTitleView.snp.leading)
            make.centerY.equalTo(editTitleView.snp.centerY)
        }
        
        // titleTextField 제약조건
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.leading.equalTo(todoImageView.snp.trailing).offset(12)
            make.trailing.equalTo(editTitleView.snp.trailing)
            make.centerY.equalTo(editTitleView.snp.centerY)
        }
        
        // bottomLine 제약조건
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(editTitleView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        // todoDateRangeView 제약조건
        todoDateRangeView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(bottomLine.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        dateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
            make.leading.equalTo(todoDateRangeView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateImageView.snp.trailing).offset(16)
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
        }
        
        arrowLabel.snp.makeConstraints { make in
            make.leading.equalTo(startDateLabel.snp.trailing).offset(12)
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(arrowLabel.snp.trailing).offset(12)
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
        }
        
        // calendarContainerView 제약조건
        calendarContainerView.snp.makeConstraints { make in
            make.top.equalTo(todoDateRangeView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(30.5)
            make.height.equalTo(0)
        }
        
        // alertView 제약조건
        alertView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(calendarContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        alertImageView.snp.makeConstraints { make in
            make.centerY.equalTo(alertView.snp.centerY)
            make.leading.equalTo(alertView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        alertLabel.snp.makeConstraints { make in
            make.leading.equalTo(alertImageView.snp.trailing).offset(16)
            make.centerY.equalTo(alertView.snp.centerY)
        }
        
        alertPickerView.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(30.5)
            make.height.equalTo(0)
        }
        
        repetitionView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(alertPickerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        repetitionImageView.snp.makeConstraints { make in
            make.centerY.equalTo(repetitionView.snp.centerY)
            make.leading.equalTo(repetitionView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        repetitionLabel.snp.makeConstraints { make in
            make.leading.equalTo(repetitionImageView.snp.trailing).offset(16)
            make.centerY.equalTo(repetitionView.snp.centerY)
        }
        
        // challengeCheckView 제약조건
        challengeCheckView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(repetitionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        challengeCheckImageView.snp.makeConstraints { make in
            make.centerY.equalTo(challengeCheckView.snp.centerY)
            make.leading.equalTo(challengeCheckView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        challengeCheckLabel.snp.makeConstraints { make in
            make.leading.equalTo(challengeCheckImageView.snp.trailing).offset(16)
            make.centerY.equalTo(challengeCheckView.snp.centerY)
        }
        
        // registerButton 제약조건
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(contentStackView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(37)
            make.height.equalTo(64)
        }
    }
    
    private func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.bottomSheetKeyboardConstraint?.update(offset: -keyboardFrame.height)
            UIView.animate(withDuration: 0.3) {
                self.registerButton.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(0)
                    make.height.equalTo(0)
                }
                self.registerButton.isHidden = true
                self.calendarContainerView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.bottomSheetKeyboardConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.registerButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(37)
                make.height.equalTo(64)
            }
            self.registerButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureGestures() {
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTapGesture)
        
        let dateRangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateRangeTapped(_:)))
        todoDateRangeView.addGestureRecognizer(dateRangeTapGesture)
        
        let alertViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(alertTapped(_:)))
        alertView.addGestureRecognizer(alertViewTapGesture)
        
        // repetitionView 탭 제스처
        let repetitionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(repetitionTapped(_:)))
        repetitionLabel.addGestureRecognizer(repetitionLabelTapGesture)
        repetitionLabel.isUserInteractionEnabled = true
        
        let repetitionImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(repetitionTapped(_:)))
        repetitionImageView.addGestureRecognizer(repetitionImageViewTapGesture)
        repetitionImageView.isUserInteractionEnabled = true
        
        let challengeCheckViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(challengeCheckTapped(_:)))
        challengeCheckView.addGestureRecognizer(challengeCheckViewTapGesture)
        
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        hideBottomSheet()
    }
    
    @objc private func dateRangeTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAllExcept(calendarContainerView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarContainerView.isHidden.toggle()
            
            if self.calendarContainerView.isHidden {
                self.calendarContainerView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self.calendarContainerView.snp.updateConstraints { make in
                    make.height.equalTo(320)
                }
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.updateUI()
        }
    }

    @objc private func alertTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAllExcept(alertPickerView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alertPickerView.isHidden.toggle()
            
            if self.alertPickerView.isHidden {
                self.alertPickerView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.alertImageView.image = .notification1
            } else {
                self.alertPickerView.snp.updateConstraints { make in
                    make.height.equalTo(126)
                }
                self.alertImageView.image = .notification2
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.updateUI()
        }
    }

    @objc private func repetitionTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAllExcept(repetitionCollectionView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.repetitionCollectionView.isHidden.toggle()
            
            if self.repetitionCollectionView.isHidden {
                self.repetitionImageView.image = .re1
                self.repetitionLabel.isHidden = false
                self.repetitionLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(self.repetitionImageView.snp.trailing).offset(16)
                    make.centerY.equalTo(self.repetitionView.snp.centerY)
                }
            } else {
                self.repetitionImageView.image = .re2
                self.repetitionLabel.isHidden = true
                self.repetitionCollectionView.snp.remakeConstraints { make in
                    make.height.equalTo(36)
                    make.leading.equalTo(self.repetitionImageView.snp.trailing).offset(16)
                    make.trailing.equalToSuperview()
                    make.centerY.equalTo(self.repetitionView.snp.centerY)
                }
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.updateUI()
        }
    }

    
    @objc private func challengeCheckTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAllExcept(nil)
        newTodo.isChallenge.toggle()
        updateUI()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideAllExcept(_ viewToExclude: UIView?) {
        if viewToExclude != calendarContainerView && !calendarContainerView.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.calendarContainerView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.view.layoutIfNeeded()
            }) { _ in
                self.updateUI()
                self.calendarContainerView.isHidden = true
            }
        }
        
        if viewToExclude != alertPickerView && !alertPickerView.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.alertPickerView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.alertImageView.image = .notification1
                self.view.layoutIfNeeded()
            }) { _ in
                self.alertPickerView.isHidden = true
            }
        }
        if viewToExclude != repetitionCollectionView && !repetitionCollectionView.isHidden {
            repetitionCollectionView.isHidden = true
            repetitionImageView.image = .re1
            repetitionLabel.isHidden = false
            repetitionLabel.snp.remakeConstraints { make in
                make.leading.equalTo(repetitionImageView.snp.trailing).offset(16)
                make.centerY.equalTo(repetitionView.snp.centerY)
            }
            self.updateUI()
        }
    }

    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        newTodo.title = textField.text ?? ""
        updateUI()
    }
    
    @objc private func titleTextFieldDidEndEditing(_ textField: UITextField) {
        newTodo.title = textField.text ?? ""
        updateUI()
    }
    
    // 투두 생성 시점
    @objc private func registerButtonTapped() {
        CoreDataManager.shared.createTodo(newTodo: newTodo)
        hideBottomSheet()
    }
    
    private func showBottomSheet() {
        self.bottomSheetKeyboardConstraint?.activate()
        self.bottomSheetInitialConstraint?.deactivate()
        self.view.layoutIfNeeded()
        updateUI()
        
        let today = Date()
        
        newTodo.startDate = today
        newTodo.endDate = nil
        newTodo.isChallenge = false
    }
    
    private func hideBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: false, completion: nil)
            self.dismissCompletion?()
        }
    }
    
    // DateExtention 으로 옮겨야할지..
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. M. d. EE"
        return dateFormatter.string(from: date)
    }
    
    private func updateUI() {
        if calendarContainerView.isHidden {
            if newTodo.endDate == nil {
                // 기한 없음
                dateImageView.image = .clock1.withTintColor(.secondary600)
                startDateLabel.textColor = .secondary600
                startDateLabel.text = "기한 없음"
                arrowLabel.isHidden = true
                endDateLabel.isHidden = true
                alertView.isHidden = true
                repetitionView.isHidden = true
                challengeCheckView.isHidden = true
            } else if newTodo.startDate == newTodo.endDate {
                // 단일 날짜 선택
                dateImageView.image = .clock2.withTintColor(.alertRed)
                startDateLabel.text = formatDate(newTodo.startDate!)
                startDateLabel.textColor = .challendarWhite
                arrowLabel.isHidden = true
                endDateLabel.isHidden = true
                alertView.isHidden = false
                repetitionView.isHidden = true
                challengeCheckView.isHidden = true
            } else if newTodo.startDate != newTodo.endDate && newTodo.endDate != nil {
                // 날짜 범위 선택
                dateImageView.image = .clock2.withTintColor(.alertRed)
                startDateLabel.text = formatDate(newTodo.startDate!)
                endDateLabel.text = formatDate(newTodo.endDate!)
                startDateLabel.textColor = .challendarWhite
                endDateLabel.textColor = .challendarWhite
                arrowLabel.isHidden = false
                endDateLabel.isHidden = false
                alertView.isHidden = false
                repetitionView.isHidden = false
                challengeCheckView.isHidden = false
            }
        } else {
            if newTodo.endDate == nil {
                print("done")
                // 기한 없음
                dateImageView.image = .clock2.withTintColor(.alertRed)
                startDateLabel.textColor = .alertBlue
                startDateLabel.text = "기한 없음"
                arrowLabel.isHidden = true
                endDateLabel.isHidden = true
                alertView.isHidden = true
                repetitionView.isHidden = true
                challengeCheckView.isHidden = true
            } else if newTodo.startDate == newTodo.endDate {
                // 단일 날짜 선택
                startDateLabel.textColor = .alertBlue
                startDateLabel.text = formatDate(newTodo.startDate!)
                arrowLabel.isHidden = true
                endDateLabel.isHidden = true
                alertView.isHidden = false
                repetitionView.isHidden = true
                challengeCheckView.isHidden = true
            } else if newTodo.startDate != newTodo.endDate && newTodo.endDate != nil {
                // 날짜 범위 선택
                startDateLabel.textColor = .alertBlue
                endDateLabel.textColor = .alertBlue
                startDateLabel.text = formatDate(newTodo.startDate!)
                endDateLabel.text = formatDate(newTodo.endDate!)
                arrowLabel.isHidden = false
                endDateLabel.isHidden = false
                alertView.isHidden = false
                repetitionView.isHidden = false
                challengeCheckView.isHidden = false
            }
        }
        
        if newTodo.isChallenge {
            challengeCheckImageView.image = .challengeCheck2
            challengeCheckLabel.text = "챌린지 도전"
            challengeCheckLabel.textColor = .challendarWhite
        } else {
            challengeCheckImageView.image = .challengeCheck1
            challengeCheckLabel.text = "챌린지 안 함"
            challengeCheckLabel.textColor = .secondary600
        }
        
        // repetitinoLabel 값 표시
        let selectedItems = selectedRepetitionDates.sorted().map { repetitionCollectionView.items[$0] }
        repetitionLabel.text = selectedItems.isEmpty ? "반복 안 함" : selectedItems.joined(separator: ", ")
        repetitionLabel.textColor = selectedItems.isEmpty ? UIColor.secondary600 : UIColor.challendarWhite
        repetitionImageView.image = selectedItems.isEmpty ? UIImage.re1 : UIImage.re2
        
        // titleTextField에 값에 따라 registerButton 활성 상태 변경
        if let titleText = titleTextField.text, titleText.isEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .secondary800
            registerButton.setTitleColor(.secondary700, for: .normal)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = newTodo.isChallenge ? .challendarGreen400 : (newTodo.startDate != nil && newTodo.endDate != nil ? .alertBlue : .alertTomato)
            registerButton.setTitleColor(newTodo.isChallenge ?  UIColor.challendarBlack : UIColor.challendarWhite, for: .normal)
        }
        
        if newTodo.endDate == nil {
            todoImageView.image = .done3.withTintColor(.alertTomato)
            titleTextField.tintColor = .alertTomato
        } else {
            todoImageView.image = newTodo.isChallenge ? .done3.withTintColor(.challendarGreen200) : .done3.withTintColor(.alertBlue)
            titleTextField.tintColor = newTodo.isChallenge ? .challendarGreen200 : .alertBlue
        }
    }
}

extension AddTodoBottomSheetViewController: NewCalendarDelegate {
    // NewCalendarDelegate 메소드
    func singleDateSelected(firstDate: Date) {
        newTodo.startDate = firstDate
        newTodo.endDate = firstDate
        updateUI()
    }
    
    func rangeOfDateSelected(firstDate: Date, lastDate: Date) {
        newTodo.startDate = firstDate
        newTodo.endDate = lastDate
        updateUI()
    }
    
    func deSelectedDate() {
        let today = Date()
        newTodo.startDate = today
        newTodo.endDate = nil
        newTodo.isChallenge = false
        updateUI()
    }
}

extension AddTodoBottomSheetViewController: AlarmPickerViewDelegate {
    func timeDidChanged(date: Date) {
        
    }
}

extension AddTodoBottomSheetViewController: RepetitionCollectionViewDelegate {
    func repetitionCollectionView(_ collectionView: RepetitionCollectionView, didSelectItemAt index: Int) {
        if selectedRepetitionDates.contains(index) {
            selectedRepetitionDates.removeAll { $0 == index }
        } else {
            selectedRepetitionDates.append(index)
        }
    }
}

