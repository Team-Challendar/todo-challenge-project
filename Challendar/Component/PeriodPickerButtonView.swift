//
//  PeriodPickerButtonView.swift
//  Challendar
//
//  Created by 채나연 on 6/5/24.
//



import UIKit
import SnapKit

// 버튼 클릭 이벤트를 처리하기 위한 델리게이트 프로토콜
protocol PeriodPickerButtonViewDelegate {
    func didTapCalButton()
    func didTapDailyButton()
}

// 현재 캘린더 상태를 나타내는 열거형
enum currentCalendar {
    case calendar
    case daily
}

// 커스텀 뷰 클래스
class PeriodPickerButtonView: UIView {
    
    // 델리게이트 변수
    var delegate: PeriodPickerButtonViewDelegate?
    
    // 현재 상태 변수
    var currentState: currentCalendar? = .calendar
    
    // 첫 번째 버튼 뷰 생성
    private let buttonView1: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary850
        let label = UILabel()
        label.text = "달력"
        label.textColor = .secondary700
        label.font = .pretendardRegular(size: 17)
        let imageView = UIImageView(image: .monthly0)
        imageView.tintColor = .secondary700
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(24) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    // 두 번째 버튼 뷰 생성
    private let buttonView2: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary850
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .secondary700
        label.font = .pretendardRegular(size: 17)
        let imageView = UIImageView(image: .daily0)
        imageView.tintColor = .secondary700
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(24) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    // 버튼 뷰 배열
    private var buttonViews: [UIView] {
        return [buttonView1, buttonView2]
    }
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI() // UI 설정
        configureConstraint() // 제약조건 설정
        configureUtil() // 유틸리티 설정
        configureButtons() // 버튼 설정
    }
    
    // 스토리보드나 Nib에서 초기화할 때 사용
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 설정 함수
    private func configureUI() {
        addSubview(buttonView1)
        addSubview(buttonView2)
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .secondary850 // 챌린지100으로 추후 수정
    }
    
    // 제약조건 설정 함수
    private func configureConstraint() {
        buttonView1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        buttonView2.snp.makeConstraints { make in
            make.top.equalTo(buttonView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        addBorders() // 경계선 추가
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
    
    // 유틸리티 설정 함수
    private func configureUtil() {
        setupActions() // 액션 설정
    }
    
    // 버튼에 액션을 설정하는 함수
    private func setupActions() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(calButtonTapped))
        buttonView1.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dailyButtonTapped))
        buttonView2.addGestureRecognizer(tapGesture2)
    }
    
    // '날짜' 버튼 클릭 시 호출되는 함수
    @objc private func dailyButtonTapped() {
        self.currentState = .daily
        self.configureButtons() // 버튼 상태 업데이트
        self.delegate?.didTapDailyButton() // 델리게이트 메서드 호출
    }
    
    // '달력' 버튼 클릭 시 호출되는 함수
    @objc private func calButtonTapped() {
        self.currentState = .calendar
        self.configureButtons() // 버튼 상태 업데이트
        self.delegate?.didTapCalButton() // 델리게이트 메서드 호출
    }
    
    // 버튼 상태를 업데이트하는 함수
    func configureButtons() {
        switch currentState {
        case .calendar:
            buttonView2.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .secondary700 }
            buttonView2.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .daily0 }
            buttonView1.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .white }
            buttonView1.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .monthly1 }
        case .daily:
            buttonView1.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .secondary700 }
            buttonView1.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .monthly0 }
            buttonView2.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .white }
            buttonView2.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .daily1 }
        default:
            return
        }
    }
}
