//
//  PickerBtnView.swift
//  Challendar
//
//  Created by 채나연 on 6/5/24.
//



import UIKit
import SnapKit

// 버튼 클릭 이벤트를 처리하기 위한 델리게이트 프로토콜
protocol PickerBtnViewDelegate: AnyObject {
    func didTapLatestOrderButton()
    func didTapRegisteredOrderButton()
}

// 커스텀 뷰 클래스
class PickerBtnView: UIView {
    
    // 델리게이트 변수
    weak var delegate: PickerBtnViewDelegate?
    
    // 등록순 버튼 생성
    private let registeredOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("등록순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardMedium(size: 17)
        return button
    }()
    
    // 최신순 버튼 생성
    private let latestOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardMedium(size: 17)
        return button
    }()
    
    // 버튼 사이 경계선 뷰 생성
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary700
        return view
    }()
    
    // 버튼 배열
    private var buttons: [UIButton] {
        return [registeredOrderBtn, latestOrderBtn]
    }
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 설정
        setupActions() // 버튼 액션 설정
    }
    
    // 스토리보드나 Nib에서 초기화할 때 사용
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 버튼 뷰 배열
    private var buttonViews: [UIView] {
        return [registeredOrderBtn, latestOrderBtn]
    }
    
    // 경계선을 추가하는 함수
    private func addBorders() {
        for (index, buttonView) in buttonViews.enumerated() {
            if index > 0 {
                let border = UIView()
                border.backgroundColor = .secondary700
                buttonView.addSubview(border)
                border.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.height.equalTo(0.5) // 경계선의 높이
                }
            }
        }
    }
    
    // 뷰 설정 함수
    private func setupView() {
        addSubview(registeredOrderBtn)
        addSubview(latestOrderBtn)
        
        // 등록순 버튼 레이아웃 설정
        registeredOrderBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        // 최신순 버튼 레이아웃 설정
        latestOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(registeredOrderBtn.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        // 최신순 버튼을 기본 선택 상태로 설정
        latestOrderBtn.isSelected = true
        latestOrderBtn.tintColor = .challendarWhite // 선택된 버튼 색상 변경
        latestOrderBtn.backgroundColor = .secondary850
        addBorders()
        
        // 뷰의 외형 설정
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .secondary850
    }
    
    // 버튼 액션 설정 함수
    private func setupActions() {
        registeredOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        latestOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    // 버튼 클릭 시 호출되는 함수
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons.forEach {
            $0.isSelected = false
            $0.tintColor = .secondary850 // 기본 색상으로 되돌림
            $0.backgroundColor = .clear // 기본 배경색으로 되돌림
        }
        sender.isSelected = true
        sender.tintColor = .challendarWhite // 선택된 버튼 색상 변경
        sender.backgroundColor = .secondary850 // 선택된 버튼 배경색 변경
        
        // 델리게이트 메서드 호출
        if sender == latestOrderBtn {
            delegate?.didTapLatestOrderButton()
        } else if sender == registeredOrderBtn {
            delegate?.didTapRegisteredOrderButton()
        }
    }
}
