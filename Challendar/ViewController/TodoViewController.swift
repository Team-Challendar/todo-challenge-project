//
//  TodoListViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

class TodoViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let pickerBtnView = PickerBtnView()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
        configureTitleNavigationBar(title: "할 일 목록")
        view.backgroundColor = .challendarBlack90
        view.addSubview(pickerBtnView)
        
        pickerBtnView.snp.makeConstraints { make in
            make.width.equalTo(77)
            make.height.equalTo(133)
            make.left.equalToSuperview().offset(300)
            make.top.equalToSuperview().offset(134) 
        }
        
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "TodoCollectionViewCell")
        collectionView.register(TodoSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoSectionHeader.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(pickerBtnView.snp.bottom).offset(10) // Adjusted spacing from picker
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureNotificationCenter(){
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dismissedFromSuccess(_:)),
            name: NSNotification.Name("DismissSuccessView"),
            object: nil
        )
    }
    
    @objc func dismissedFromSuccess(_ notification: Notification) {
        // 알림 수신시 수행할 작업
    }
    
    // UICollectionViewDataSource 메서드
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // 첫 번째 섹션의 셀 수
        } else {
            return 4 // 두 번째 섹션의 셀 수
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCollectionViewCell", for: indexPath) as? TodoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = "할 일 \(indexPath.item + 1)"
        return cell
    }
    
    // 헤더 뷰 구성
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TodoSectionHeader.identifier, for: indexPath) as! TodoSectionHeader
        header.titleLabel.text = indexPath.section == 0 ? "할 일" : "완료된 목록"
        
        return header
    }
    
    // 헤더 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 75) // left and right insets of 16
    }

    // 셀 간 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 50 : 10 // Increased spacing after the first section
    }
}

