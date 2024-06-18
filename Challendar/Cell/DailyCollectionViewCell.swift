//
//  DailyCollectionViewCell.swift
//  Challendar
//
//  Created by 채나연 on 5/30/24.

import UIKit
import SnapKit

//UIView를 상속받아 데일리 뷰를 정의
class DailyView: UIView {
    var days: [Day]?
    var dateLabel = UILabel()
    let layout = YZCenterFlowLayout()
    var collectionView: UICollectionView!
    var currentDate: Date?
    let visibleItemsThreshold = 4
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView() // 컬렉션 뷰 설정
        configureConstraint() // 제약 조건 설정
        backgroundColor = .clear
    }
    
    // 코드 기반 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 라벨의 텍스트를 설정하고 컬렉션 뷰의 데이터를 다시 로드
    func configure(with days: [Day], selectedDate: Date?) {
        configureDateLabel(date: selectedDate) // 라벨 설정
        currentDate = selectedDate
        self.days = days
        collectionView.reloadData()
    }
    
    // 날짜 라벨을 설정하는 함수
    func configureDateLabel(date: Date?) {
        dateLabel.text = DateFormatter.dateFormatter.string(from: date ?? Date())
        dateLabel.font = .pretendardBold(size: 16)
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = .secondary700
        updateLabel(date ?? Date())
    }
    
    // 제약 조건을 설정하는 함수
    func configureConstraint() {
        self.addSubview(dateLabel)
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(25)
            $0.height.equalTo(244)
            $0.leading.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    // 컬렉션 뷰를 설정하는 함수
    func configureCollectionView() {
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(198, 244)
        layout.animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0.64, sideItemAlpha: 0.6, sideItemShift: 0)
        layout.spacingMode = .fixed(spacing: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 라벨 텍스트를 업데이트하는 함수
    func updateLabel(_ date: Date) {
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        dateLabel.attributedText = attributedString
    }
}

// UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate 프로토콜 채택
extension DailyView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // 섹션 내 아이템 수를 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days?.count ?? 0
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }
        if let days = days {
            let data = days[indexPath.row]
            cell.configure(day: data)
            if currentDate?.isSameDay(as: data.date) == true {
                cell.configureSelectedDate()
            }
        }
        return cell
    }
    
    // 스크롤이 멈췄을 때 호출되는 함수
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let page = layout.currentCenteredPage {
            NotificationCenter.default.post(name: NSNotification.Name("date"), object: days?[page].date, userInfo: nil)
        }
    }
}

