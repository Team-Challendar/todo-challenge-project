//
//  SearchViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private var items: [TodoModel] = todos
    private var filteredItems: [TodoModel] = []
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        
        searchBarConfigure() // 서치바 설정
        
        setupCollectionView()
        setupLayout()
        filteredItems = items  // 초기화
        reload()
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SearchSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // 아이템 크기 설정 (높이 고정: 75, 너비는 섹션에 맞추기)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // 그룹 크기 설정 (높이 고정: 75, 너비는 섹션에 맞추기)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16) // 아이템 사이 간격 16
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16 // 그룹 사이 간격 16
        
        // 섹션 헤더 설정
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        // 레이아웃 설정
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func reload() {
        self.collectionView.reloadData()
    }
    
    private func searchBarConfigure() {
        // UISearchBar 객체를 생성하고 설정
        searchBar = UISearchBar()
        searchBar.delegate = self // 델리게이트를 설정하여 이벤트 처리
        searchBar.placeholder = "검색어를 입력하세요" // 플레이스홀더 텍스트 설정
        searchBar.setValue("취소", forKey: "cancelButtonText") // 취소 버튼의 텍스트를 "취소"로 설정
        searchBar.showsCancelButton = false // 취소 버튼을 기본적으로 숨김
        
        // 서치바를 네비게이션 바의 titleView로 설정
        navigationItem.titleView = searchBar
        
        searchBarTextFieldConfigure() // 서치바의 텍스트 필드를 커스텀하기 위한 메소드 호출
    }
    
    private func searchBarTextFieldConfigure() {
        // 서치바의 텍스트 필드에 대한 설정
        guard let searchTextField = searchBar.value(forKey: "searchField") as? UITextField else {
            return
        }
        
        searchTextField.backgroundColor = .challendarBlack80 // 배경색을 설정
        searchTextField.font = UIFont.systemFont(ofSize: 18) // 폰트 크기 설정
        searchTextField.layer.borderColor = UIColor.init(white: 1, alpha: 0.02).cgColor // 테두리 색상 설정
        searchTextField.layer.borderWidth = 1 // 테두리 두께 설정
        searchTextField.layer.cornerRadius = 12 // 테두리 모서리 둥글게 설정
        searchTextField.clipsToBounds = true // 코너 둥글게 설정을 적용
        searchTextField.tintColor = .challendarBlack80 // 틴트 색상 설정
        searchTextField.textColor = .white // 타이핑되는 글씨 색상 설정
        
        // 플레이스홀더 텍스트 색상 설정
        if let placeholderText = searchBar.placeholder {
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.challendarBlack60]
            )
        }
        
        if let image = UIImage(systemName: "magnifyingglass") {
            setLeftImage(image, for: searchTextField)
        } else {
            print("Image not found")
        }
        
        // searchTextField 크기 조정
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 4),
            searchTextField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -12),
            searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -16)
        ])
    }
    
    private func setLeftImage(_ image: UIImage, for textField: UITextField) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 8, y: 0, width: 22, height: 22) // 좌측 패딩 8
        imageView.tintColor = .challendarBlack60
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 22))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func updateSearchTextFieldConstraints(showingCancelButton: Bool) {
        guard let searchTextField = searchBar.value(forKey: "searchField") as? UITextField else {
            return
        }

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(searchTextField.constraints)

        let trailingConstant: CGFloat = showingCancelButton ? -56 : -16

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 4),
            searchTextField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -4),
            searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: trailingConstant)
        ])
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 완료 투두와 미완료 투두 두 섹션
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return filteredItems.filter { $0.progress == 1.0 }.count
        } else {
            return filteredItems.filter { $0.progress! < 1.0 }.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        let item: TodoModel
        if indexPath.section == 0 {
            item = filteredItems.filter { $0.progress == 1.0 }[indexPath.row]
        } else {
            item = filteredItems.filter { $0.progress! < 1.0 }[indexPath.row]
        }
        cell.TitleLabel.text = item.name
        cell.contentView.backgroundColor = .challendarBlack80
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SearchSectionHeader
        
        let itemCount = (indexPath.section == 0) ? filteredItems.filter { $0.progress == 1.0 }.count : filteredItems.filter { $0.progress! < 1.0 }.count
        header.isHidden = (itemCount == 0)
        
        if !header.isHidden {
            header.sectionLabel.text = indexPath.section == 0 ? "완료 투두" : "미완료 투두"
            header.sectionLabel.textColor = .challendarBlack60
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        
        if previousIndexPath == indexPath {
            selectedIndexPath = nil
        }
        
        collectionView.reloadItems(at: [indexPath])
        
        if let previousIndexPath = previousIndexPath {
            collectionView.reloadItems(at: [previousIndexPath])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
        self.reload()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        updateSearchTextFieldConstraints(showingCancelButton: false)
        filterItems(with: "")
        self.reload()
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        updateSearchTextFieldConstraints(showingCancelButton: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        updateSearchTextFieldConstraints(showingCancelButton: false)
    }
}

class SearchSectionHeader: UICollectionReusableView {
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .cyan
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
