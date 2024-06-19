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
    var editTitleView = UIView()
    var todoImageView = UIImageView()
    var titleTextField = UITextField()
    var bottomLine = UIView()
    var dismissCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        configureGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        // editTitleView 설정
        editTitleView.backgroundColor = .clear
        bottomSheetView.addSubview(editTitleView)
        
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
        bottomSheetView.addSubview(bottomLine)
    }
    
    private func configureConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(142)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        // editTitleView 제약조건
        editTitleView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(bottomSheetView.snp.top).offset(16)
            make.leading.trailing.equalTo(bottomSheetView).inset(16)
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
            make.leading.trailing.equalTo(bottomSheetView).inset(16)
            make.top.equalTo(editTitleView.snp.bottom).offset(10)
        }
    }
    
    // 바텀시트 외의 부분 터치 시 GestureRecognizer
    private func configureGestures() {
        let dimmedTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTapGesture)
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheet()
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: false, completion: nil)
            self.dismissCompletion?()
        }
    }
}

// ViewController에서 BottomSheet 호출하는 부분 예시
class ViewController: UIViewController {
    let showBottomSheetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(showBottomSheetButton)
        showBottomSheetButton.setTitle("Show Bottom Sheet", for: .normal)
        showBottomSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
        
        showBottomSheetButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func showBottomSheet() {
        let bottomSheetVC = AddTodoBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dismissCompletion = {
            // BottomSheet가 닫힌 후 처리할 로직
        }
        present(bottomSheetVC, animated: false, completion: nil)
    }
}
