//
//  CollectionViewCell.swift
//  Challendar
//
//  Created by 채나연 on 5/30/24.

import UIKit
import SnapKit

class DailyCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단 캐로셀 컬렉션 뷰 설정
    var testCollectionView: UICollectionView = {
        let layout = YZCenterFlowLayout()
        
        // 캐로셀 방향 설정
        layout.scrollDirection = .horizontal
        
        // 애니메이션 모드 설정
        layout.animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0.6, sideItemAlpha: 0.6, sideItemShift: 0.0)
        
        // 셀 간격 설정
        layout.spacingMode = .fixed(spacing: -3)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        
        return collectionView
    }()
    
    // 더미 데이터 배열
    private let dummyData: [(day: String, date: String)] = [
        ("월요일", "27"),
        ("화요일", "28"),
        ("수요일", "29"),
        ("목요일", "30"),
        ("금요일", "31"),
        ("토요일", "01"),
        ("일요일", "02"),
        ("월요일", "03"),
        ("화요일", "04"),
        ("수요일", "05")
    ]
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 뷰의 배경색 설정
        backgroundColor = .challendarBlack90
        
        // 테스트 컬렉션 뷰를 현재 뷰의 서브뷰로 추가
        contentView.addSubview(testCollectionView)
        
        // 테스트 컬렉션 뷰의 제약 조건을 설정하여 슈퍼 뷰와 동일한 크기로 만듭니다.
        testCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 테스트 컬렉션 뷰의 델리게이트, 데이터소스를 현재 클래스로 설정
        testCollectionView.delegate = self
        testCollectionView.dataSource = self
        
        // 테스트 컬렉션 뷰의 배경색을 challendarBlack90 으로 수정
        testCollectionView.backgroundColor = .black

        // Label을 contentView에 추가
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // 코드 기반 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // label의 텍스트를 설정하고 testCollectionView의 데이터를 다시 로드
    func configure(with text: String) {
        label.text = text
        testCollectionView.reloadData()
    }
    
    // 레이블 설정
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white // 텍스트 색상을 흰색으로 설정
        label.font = .pretendardSemiBold(size: 18)
        return label
    }()
    
    // 콜렉션뷰에 10개의 셀을 선언
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }
        
        let data = dummyData[indexPath.row]
        cell.configure(day: data.day, date: data.date)
        
        return cell
    }
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 194, height: 244)
    }

    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        print (indexPath)
    }
}
