//
//  WeeklyViewController.swift
//  Challendar
//
//  Created by 채나연 on 6/6/24.
//

import UIKit
import SnapKit

class DailyViewController: BaseViewController {
    
    // 콜렉션뷰 선언 (지연 초기화 사용)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical  // 스크롤 방향을 수직으로 설정
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 등록
        collectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: "DailyCollectionViewCell")
        
        // 델리게이트 및 데이터 소스 설정
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 콜렉션뷰 설정
    override func configureUI() {
        super.configureUI()
        view.addSubview(collectionView)  // 콜렉션뷰를 서브뷰로 추가
        
        // SnapKit을 사용하여 콜렉션뷰의 제약 조건 설정
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)  // 콜렉션뷰를 안전 영역에 맞춤
        }
    }
}

// UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout 구현을 extension으로 분리
extension DailyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 콜렉션뷰에 3개의 섹션을 선언
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // 각 섹션에 한 개의 셀 넣어주기
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell", for: indexPath) as? DailyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 첫 번째 섹션의 셀에 대한 설정
        if indexPath.section == 0 {
            cell.testCollectionView.isHidden = false
        } else {
            cell.testCollectionView.isHidden = true
        }
        
        return cell
    }
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 393, height: 244)
    }
}
