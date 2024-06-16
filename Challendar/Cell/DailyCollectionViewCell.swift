//
//  CollectionViewCell.swift
//  Challendar
//
//  Created by 채나연 on 5/30/24.

import UIKit
import SnapKit

class DailyView: UIView {
    var days : [Day]?
    var dateLabel = UILabel()
    let layout = YZCenterFlowLayout()
    // 상단 캐로셀 컬렉션 뷰 설정
    var collectionView: UICollectionView!
    var currentDate : Date?
    let visibleItemsThreshold = 4
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureConstraint()
        backgroundColor = .clear
    }
    
    // 코드 기반 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // label의 텍스트를 설정하고 testCollectionView의 데이터를 다시 로드
    func configure(with days: [Day], selectedDate: Date?) {
        configureDateLabel(date: selectedDate)
        currentDate = selectedDate!
        self.days = days
        collectionView.reloadData()
        
    }
    func configureDateLabel(date: Date?){
        dateLabel.text = DateFormatter.dateFormatter.string(from: date ?? Date())
        dateLabel.font = .pretendardBold(size: 16)
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = .secondary700
        updateLabel(date ?? Date())
    }
    func configureConstraint(){
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
    func configureCollectionView(){
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(198, 244)
        // 애니메이션 모드 설정
        layout.animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0.64, sideItemAlpha: 0.6, sideItemShift: 0)
        
        // 셀 간격 설정
        layout.spacingMode = .fixed(spacing: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func updateLabel(_ date: Date) {
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        dateLabel.attributedText = attributedString
    }
}

extension DailyView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // 콜렉션뷰에 10개의 셀을 선언
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
            if (currentDate!.isSameDay(as: data.date)){
                cell.configureSelectedDate()
            }
        }
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let page = layout.currentCenteredPage {
            NotificationCenter.default.post(name: NSNotification.Name("date"), object: days![page].date, userInfo: nil)
//            if page <= 4 {
//                NotificationCenter.default.post(name: NSNotification.Name("AddDaysFront"), object: days![page].date.prevMonth(), userInfo: nil)
//            }
//            if let count = days?.count {
//                if page >= count - 4 {
//                    NotificationCenter.default.post(name: NSNotification.Name("AddDaysBack"), object: days![page].date.nextMonth(), userInfo: nil)
//                }
//            }
//            
        }
    }
}
