//
//  AddTodoBottomSheetViewController.swift
//  Challendar
//
//  Created by 서혜림 on 6/19/24.
//

import UIKit
import SnapKit

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
    var calendarView = UIView()
    
    var alertView = UIView()
    var alertImageView = UIImageView()
    var alertLabel = UILabel()
    var dismissCompletion: (() -> Void)?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        titleTextField.becomeFirstResponder()
        
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
        
        // calendarView 설정
        calendarView.backgroundColor = .secondary850
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.secondary800.cgColor
        calendarView.layer.cornerRadius = 20
        calendarView.isHidden = true
        contentStackView.addArrangedSubview(calendarView)
        
        // alertView 설정
        alertView.backgroundColor = .clear
        contentStackView.addArrangedSubview(alertView)
        
        alertImageView.backgroundColor = .clear
        alertImageView.image = .clock1.withTintColor(.secondary600)
        alertView.addSubview(alertImageView)
        
        alertLabel.text = "알람 없음"
        alertLabel.textColor = .secondary600
        alertLabel.font = .pretendardMedium(size: 16)
        alertView.addSubview(alertLabel)
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
            make.bottom.equalToSuperview().inset(32)
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
            make.leading.trailing.equalToSuperview()
        }
        
        // todoDateRangeView 제약조건
        todoDateRangeView.snp.makeConstraints { make in
            make.height.equalTo(36)
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
        
        // calendarView 제약조건
        calendarView.snp.makeConstraints { make in
            make.width.equalTo(300)
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
    }
    
    private func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.0) {
                self.bottomSheetKeyboardConstraint?.update(offset: -keyboardFrame.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.0) {
            self.bottomSheetKeyboardConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    // 바텀시트 외의 부분 터치 시 GestureRecognizer
    private func configureGestures() {
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTapGesture)
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(viewTapGesture)
        
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
        UIView.animate(withDuration: 0.3) {
            self.calendarView.isHidden.toggle()
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
        }
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.0) {
            self.bottomSheetKeyboardConstraint?.activate()
            self.bottomSheetInitialConstraint?.deactivate()
            self.view.layoutIfNeeded()
        }
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
}
