//
//  ConfirmButton.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
// 메인 버튼 상황별 함수
class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    // 기본 Setup
    private func setup() {
        self.setTitle("다음", for: .normal)
        self.titleLabel?.font = .pretendardMedium(size: 18)
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        normalState()
    }
    // 버튼 이름 변경
    func changeTitle(title: String){
        self.setTitle(title, for: .normal)
    }
    // 기본 상태
    func normalState(){
        self.isEnabled = false
        self.backgroundColor = .secondary800
        self.setTitleColor(.secondary700, for: .normal)
    }
    // 하이라이트 상태 (확인 / enable 한 상태)
    func highLightState(){
        self.isEnabled = true
        self.backgroundColor = .challendarGreen200
        self.setTitleColor(.challendarBlack, for: .normal)
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    // 나중에 정할래요 버튼
    func laterState(){
        changeTitle(title: "나중에 정할래요")
        self.isEnabled = true
        self.setTitleColor(.challendarGreen200, for: .normal)
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.challendarGreen200.cgColor
        self.layer.borderWidth = 1
        self.titleLabel?.font = .pretendardMedium(size: 18)
    }
    // 적용하기 버튼
    func applyState(){
        self.isEnabled = true
        changeTitle(title: "적용하기")
        self.setTitleColor(.challendarBlack, for: .normal)
        self.backgroundColor = .challendarGreen200
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    // 적용하기 버튼 / 비활성화 상태
    func nonApplyState(){
        self.isEnabled = false
        changeTitle(title: "적용하기")
        self.setTitleColor(.secondary800, for: .normal)
        self.backgroundColor = .secondary700
        self.titleLabel?.font = .pretendardMedium(size: 18)
    }
    // Chanllenge 선태 여부 화면 버튼 (계획하기)
    func laterMediumState() {
        changeTitle(title: "계획하기")
        self.layer.cornerRadius = 12
        self.isEnabled = true
        self.setTitleColor(.challendarGreen200, for: .normal)
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.challendarGreen200.cgColor
        self.layer.borderWidth = 1
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
    // Chanllenge 선태 여부 화면 버튼 (도전하기)
    func challengeState(){
        self.isEnabled = true
        self.layer.cornerRadius = 12
        changeTitle(title: "도전하기")
        self.setTitleColor(.challendarBlack, for: .normal)
        self.backgroundColor = .challendarGreen200
        self.titleLabel?.font = .pretendardSemiBold(size: 18)
    }
}
