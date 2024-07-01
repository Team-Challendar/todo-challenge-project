//
//  FloatingBtnNew.swift
//  Challendar
//
//  Created by 채나연 on 6/14/24.
//


import UIKit

// 커스텀 UIButton 서브클래스
class FloatingBtnNew: UIButton {
    
    // 프로그래밍적으로 버튼을 생성하기 위한 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup() // 버튼 속성 설정
    }
    
    // 스토리보드나 Nib에서 버튼을 생성하기 위한 초기화 메서드
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup() // 버튼 속성 설정
    }
    
    // 버튼 속성을 설정하는 함수
    private func setup() {
        self.backgroundColor = .alertEmerald // 배경 색상 설정
        self.setImage(.fab.withTintColor(.challendarBlack, renderingMode: .alwaysOriginal), for: .normal) // 특정 틴트 색상으로 버튼 이미지 설정
        self.layer.cornerRadius = 60 / 2 // 원형 버튼을 위해 코너 반경 설정
        self.layer.borderColor = UIColor.secondary600.cgColor // 테두리 색상 설정
        self.layer.borderWidth = 1 // 테두리 두께 설정
        self.clipsToBounds = true // 버튼이 경계를 벗어나지 않도록 설정
        setupShadow() // 그림자 속성 설정
    }
    
    // 그림자 속성을 설정하는 함수
    private func setupShadow(){
        self.layer.masksToBounds = false // 그림자를 보이게 하기 위해 마스크 투 바운드를 비활성화
        self.layer.shadowOpacity = 1 // 그림자 불투명도 설정
        self.layer.shadowRadius = 8 // 그림자 흐림 반경 설정
        self.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 오프셋 설정
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45).cgColor // 불투명도를 포함한 그림자 색상 설정
    }
    
    // 버튼의 고정 크기를 제공하기 위해 intrinsicContentSize 재정의
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60) // 크기를 60x60으로 설정
    }
}
