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
    var dateRangeLabel = UILabel()
    var calendarContainerView = NewCalendarView()
    
    var alertView = UIView()
    var alertImageView = UIImageView()
    var alertLabel = UILabel()
    
    var registerButton = UIButton()
    var dismissCompletion: (() -> Void)?
    
    var newTodo = Todo()
    
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
        
        dateRangeLabel.text = "기한 없음"
        dateRangeLabel.textColor = .secondary600
        dateRangeLabel.font = .pretendardMedium(size: 16)
        todoDateRangeView.addSubview(dateRangeLabel)
        
        calendarContainerView.backgroundColor = .clear
        calendarContainerView.isHidden = true
        calendarContainerView.delegate = self
        contentStackView.addArrangedSubview(calendarContainerView)
        
        
        // alertView 설정
        alertView.backgroundColor = .clear
        alertView.isHidden = true
        contentStackView.addArrangedSubview(alertView)
        
        alertImageView.backgroundColor = .clear
        alertImageView.image = .clock1.withTintColor(.secondary600)
        alertView.addSubview(alertImageView)
        
        alertLabel.text = "알람 없음"
        alertLabel.textColor = .secondary600
        alertLabel.font = .pretendardMedium(size: 16)
        alertView.addSubview(alertLabel)
        
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
        }
        
        // dateImageView 제약조건
        dateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
            make.leading.equalTo(todoDateRangeView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        // dateRangeLabel 제약조건
        dateRangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateImageView.snp.trailing).offset(16)
            make.centerY.equalTo(todoDateRangeView.snp.centerY)
        }
        
        calendarContainerView.snp.makeConstraints { make in
            make.top.equalTo(todoDateRangeView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(30.5)
            make.height.equalTo(320)
        }
        
        // alertView 제약조건
        alertView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        // alertImageView 제약조건
        alertImageView.snp.makeConstraints { make in
            make.centerY.equalTo(alertView.snp.centerY)
            make.leading.equalTo(alertView.snp.leading)
            make.height.width.equalTo(24)
        }
        
        // alertLabel 제약조건
        alertLabel.snp.makeConstraints { make in
            make.leading.equalTo(alertImageView.snp.trailing).offset(16)
            make.centerY.equalTo(alertView.snp.centerY)
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
                make.height.equalTo(64)
            }
            self.registerButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }

    // 바텀시트 외의 부분 터치 시 GestureRecognizer
    private func configureGestures() {
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTapGesture)
        
//        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
//        bottomSheetView.addGestureRecognizer(viewTapGesture)
        
        let dateRangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateRangeTapped(_:)))
        todoDateRangeView.addGestureRecognizer(dateRangeTapGesture)
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        hideBottomSheet()
    }
    
    @objc private func viewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func dateRangeTapped(_ tapRecognizer: UITapGestureRecognizer) {
        calendarContainerView.isHidden.toggle()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
        })
    }
    
    @objc private func titleTextFieldDidEndEditing(_ textField: UITextField) {
        newTodo.title = textField.text ?? ""
    }
    
    @objc private func registerButtonTapped() {
        CoreDataManager.shared.createTodo(newTodo: newTodo)
        hideBottomSheet()
    }
    
    private func showBottomSheet() {
        self.bottomSheetKeyboardConstraint?.activate()
        self.bottomSheetInitialConstraint?.deactivate()
        self.view.layoutIfNeeded()
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

    private func updateStatus() {
        todoImageView.tintColor = .alertBlue
        registerButton.backgroundColor = .alertBlue
        registerButton.setTitle("계획 추가하기", for: .normal)
        alertView.isHidden = false
    }
}


extension AddTodoBottomSheetViewController : NewCalendarDelegate {
    // NewCalendarDelegate 메소드
    func singleDateSelected(firstDate: Date) {
        newTodo.startDate = firstDate
        newTodo.endDate = firstDate
        dateRangeLabel.text = "\(firstDate.dateToString())"
        updateStatus()
    }
    
    func rangeOfDateSelected(firstDate: Date, lastDate: Date) {
        newTodo.startDate = firstDate
        newTodo.endDate = lastDate
        dateRangeLabel.text = "\(firstDate.dateToString()) - \(lastDate.dateToString())"
        updateStatus()
    }
    
    func deSelectedDate() {
        newTodo.startDate = Date()
        newTodo.endDate = Date().endOfDay()
        dateRangeLabel.text = "기한 없음"
        alertView.isHidden = true
    }
}
