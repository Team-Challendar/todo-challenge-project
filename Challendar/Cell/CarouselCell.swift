//
//  CarouselCell.swift
//  Challendar
//
//  Created by 채나연 on 6/4/24.
//

import UIKit


// CarouselCell 클래스는 UICollectionViewCell을 상속받아 만든 사용자 정의 셀 클래스
class CarouselCell: UICollectionViewCell {
    
    // 컨테이너 뷰 설정
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary800
        view.layer.cornerRadius = 30.0
        return view
    }()
    
    // 요일 레이블 설정
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendardSemiBold(size: 24)
        label.textAlignment = .center
        return label
    }()
    
    // 날짜 레이블 설정
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white // 날짜 텍스트 색상을 흰색으로 설정
        label.font = .pretendardSemiBold(size: 58)
        label.textAlignment = .center
        return label
    }()
    
    // 날짜 배경 뷰 설정
    private lazy var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 34.5 // 기존 43.125에서 수정
        view.layer.masksToBounds = true
        return view
    }()
    
    // 날짜 컨테이너 뷰 설정
    private lazy var dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 43.125 // 86.25 / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // 코드 기반 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰 설정 메서드
    private func setupView() {
        // 내부 셀에 대한 추가 설정이 필요한 경우 여기에 작성
        
        // 컨테이너 뷰 추가
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 요일 레이블 추가
        container.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 날짜 배경 뷰 추가
        container.addSubview(dateBackgroundView)
        dateBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(126.5) // 높이와 너비를 126.5로 설정
        }
        
        // 날짜 컨테이너 뷰 추가
        container.addSubview(dateContainerView)
        dateContainerView.snp.makeConstraints { make in
            make.center.equalTo(dateBackgroundView)
            make.width.height.equalTo(86.25) // 높이와 너비를 86.25 * 86.25로 설정
        }
        
        // 날짜 레이블 추가
        container.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.center.equalTo(dateBackgroundView)
        }
    }
    
    // 데이터를 설정하는 메서드
    func configure(day: Day) {
        dayLabel.text = day.date.formatDateWeekdayString()
        dateLabel.text = day.date.formatDateToDayString()
        dateBackgroundView.backgroundColor = colorByPercentage(percentage: day.percentage)
        dateContainerView.backgroundColor = .clear
    }
    func configureSelectedDate(){
        dateContainerView.backgroundColor = .challendarBlack
    }
    private func colorByPercentage(percentage : Double) -> UIColor {
        switch percentage{
        case 0:
            return .clear
        case 0..<20:
            return .challendarBlue100
        case 20..<40:
            return .challendarBlue200
        case 40..<60:
            return .challendarBlue300
        case 60..<80:
            return .challendarBlue400
        case 80..<100:
            return .challendarBlue500
        case 100:
            return .challendarBlue600
        default:
            return .clear
        }
    }
}

