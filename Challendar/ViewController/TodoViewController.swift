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
        
        setupCollectionView()
        
        view.addSubview(dropdownButtonView)
        view.addSubview(pickerBtnView)
        pickerBtnView.isHidden = true // 처음에는 숨김 상태로 설정
        dropdownButtonView.delegate = self // 델리게이트 설정
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
            make.width.equalTo(69)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(106)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dropdownButtonView.snp.bottom).offset(10)
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
        pickerBtnView.isHidden.toggle() // 드롭다운 항목 선택 시 pickerBtnView의 숨김 상태를 토글
    }
    
    func dropdownButtonTapped() {
        pickerBtnView.isHidden.toggle() // 버튼 클릭 시 pickerBtnView의 숨김 상태를 토글
    }
}

class TodoCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 361, height: 75)
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

