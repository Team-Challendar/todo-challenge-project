//
//  TodoListViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

class TodoViewController: BaseViewController {
    
    private let pickerBtnView = PickerBtnView()
    private let dropdownButtonView = DropdownButtonView()
    private var collectionView: UICollectionView!
    private var collectionViewDelegate: TodoCollectionViewDelegate!
    private var collectionViewDataSource: TodoCollectionViewDataSource!

    override func configureUI() {
        super.configureUI()
        configureFloatingButton()
        configureTitleNavigationBar(title: "할 일 목록")
        view.backgroundColor = .challendarBlack90
        view.addSubview(pickerBtnView)
        view.addSubview(dropdownButtonView)
        setupCollectionView()
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        
        pickerBtnView.snp.makeConstraints { make in
            make.width.equalTo(77)
            make.height.equalTo(133)
            make.leading.equalToSuperview().offset(300)
            make.top.equalToSuperview().offset(134)
        }
        
        dropdownButtonView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(90) // Adjust this value as needed
            make.trailing.equalToSuperview().offset(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dropdownButtonView.snp.bottom).offset(10) // Adjusted spacing from picker
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureNotificationCenter() {
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionViewDelegate = TodoCollectionViewDelegate()
        collectionViewDataSource = TodoCollectionViewDataSource()
        
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "TodoCollectionViewCell")
        collectionView.register(TodoSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoSectionHeader.identifier)
        
        view.addSubview(collectionView)
    }
}

extension TodoViewController: DropdownButtonViewDelegate {
    func didSelectOption(_ option: String) {
        // Handle the dropdown option selection
        print("Selected option: \(option)")
    }
}

class TodoCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 361, height: 75) // Adjusted to specified width and height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 50 : 10 // Increased spacing after the first section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
}

class TodoCollectionViewDataSource: NSObject, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TodoSectionHeader.identifier, for: indexPath) as! TodoSectionHeader
        header.titleLabel.text = indexPath.section == 0 ? "할 일" : "완료된 목록"
        
        return header
    }
}

