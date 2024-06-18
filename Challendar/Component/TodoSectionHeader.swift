//
//  TodoSectionHeader.swift
//  Challendar
//
//  Created by 채나연 on 6/5/24.
//



import UIKit
import SnapKit

// TodoSectionHeader 클래스는 UICollectionReusableView를 상속받아 섹션 헤더를 정의
class TodoSectionHeader: UICollectionReusableView {
    // 재사용 식별자
    static let identifier = "TodoSectionHeader"
    
    // 헤더 라벨 생성
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 14)
        label.textColor = .secondary600
        return label
    }()
    
    // 삭제 버튼 생성
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("지우기", for: .normal) // 버튼 텍스트 설정
        button.setTitleColor(.secondary600, for: .normal) // 텍스트 색상을 .secondary600으로 설정
        button.titleLabel?.font = .pretendardRegular(size: 14) // 폰트를 .pretendardRegular(size: 14)로 설정
        button.backgroundColor = .secondary900 // 배경색을 .secondary900으로 설정
        button.isHidden = true // 기본적으로는 숨김 상태로 설정
        button.sizeToFit() // 버튼의 크기를 텍스트에 맞게 조정
        return button
    }()
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews() // 뷰 설정
        configureConstraints() // 제약조건 설정
    }
    
    // 스토리보드나 Nib에서 초기화할 때 사용
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰 설정 함수
    private func setupViews() {
        addSubview(headerLabel) // 헤더 라벨 추가
        addSubview(deleteButton) // 삭제 버튼 추가
    }
    
    // 제약조건 설정 함수
    private func configureConstraints() {
        // 헤더 라벨 제약조건 설정
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview() // 슈퍼뷰의 왼쪽에 맞춤
            make.centerY.equalToSuperview().offset(-5) // 수직 중앙에 맞추고 약간 위로 이동
        }
        
        // 삭제 버튼 제약조건 설정
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview() // 슈퍼뷰의 오른쪽에 맞춤
            make.centerY.equalTo(headerLabel.snp.centerY) // 헤더 라벨의 수직 중앙에 맞춤
        }
    }
    
    // 삭제 버튼을 보이게 하는 함수
    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    
    // 삭제 버튼을 숨기는 함수
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
}
