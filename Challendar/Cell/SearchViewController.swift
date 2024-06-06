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
    private var filteredChallengeItems: [TodoModel] = []
    private var filteredNonChallengeItems: [TodoModel] = []
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var customCancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        searchBarConfigure()
        setupCollectionView()
        setupLayout()
        filterItems(with: "")
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
        collectionView.register(UICollectionReusableView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Empty")
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SearchSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func reload() {
        self.collectionView.reloadData()
    }
    
    private func searchBarConfigure() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        navigationItem.titleView = searchBar
        searchBarTextFieldConfigure()
        
        // Create a custom button view for the cancel button
        let cancelBtn = UIView()
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 40)
        cancelBtn.isUserInteractionEnabled = true
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelText = UILabel()
        cancelText.text = "취소"
        cancelText.font = .pretendardSemiBold(size: 16)
        cancelText.textColor = .white
        cancelBtn.addSubview(cancelText)
        cancelText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelText.leadingAnchor.constraint(equalTo: cancelBtn.leadingAnchor, constant: 8),
            cancelText.trailingAnchor.constraint(equalTo: cancelBtn.trailingAnchor, constant: -8),
            cancelText.centerYAnchor.constraint(equalTo: cancelBtn.centerYAnchor)
        ])
        // 취소 기능 확정 후 작성
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTap))
        //        cancelBtn.addGestureRecognizer(tapGesture)
        
        customCancelButton = UIBarButtonItem(customView: cancelBtn)
    }
    // 취소 기능 확정 후 수정
    //    @objc func cancelButtonTap() {
    //        searchBar.setShowsCancelButton(false, animated: true)
    //        navigationItem.rightBarButtonItem = nil // Hide the custom cancel button
    //        updateSearchTextFieldConstraints(showingCancelButton: false)
    //    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true) // Hide default cancel button
        navigationItem.rightBarButtonItem = customCancelButton // Show custom cancel button
        updateSearchTextFieldConstraints(showingCancelButton: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.rightBarButtonItem = nil // Hide the custom cancel button
        updateSearchTextFieldConstraints(showingCancelButton: false)
    }
    
    private func searchBarTextFieldConfigure() {
        guard let searchTextField = searchBar.value(forKey: "searchField") as? UITextField else {
            return
        }
        
        searchTextField.backgroundColor = .challendarBlack80
        searchTextField.font = .pretendardMedium(size: 18)
        searchTextField.layer.borderColor = UIColor.init(white: 1, alpha: 0.02).cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 12
        searchTextField.clipsToBounds = true
        searchTextField.tintColor = .challendarBlack80
        searchTextField.textColor = .white
        
        if let placeholderText = searchBar.placeholder {
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    NSAttributedString.Key.font: UIFont.pretendardRegular(size: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.challendarBlack60
                ]
            )
        }
        
        if let image = UIImage(systemName: "magnifyingglass") {
            setLeftImage(image, for: searchTextField)
        } else {
            print("Image not found")
        }
        
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
        imageView.frame = CGRect(x: 8, y: 0, width: 22, height: 22)
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
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredChallengeItems = items.filter { $0.isChallenge == true }
            filteredNonChallengeItems = items.filter { $0.isChallenge == false }
        } else {
            filteredChallengeItems = items.filter { $0.isChallenge == true && $0.name.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNonChallengeItems = items.filter { $0.isChallenge == false && $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        }
        reload() // 필터링 후 데이터 리로드
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSection = 0
        if !filteredChallengeItems.isEmpty{
            numberOfSection += 1
        }
        if !filteredNonChallengeItems.isEmpty{
            numberOfSection += 1
        }
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !filteredChallengeItems.isEmpty && !filteredNonChallengeItems.isEmpty {
            return section == 0 ? filteredChallengeItems.count : filteredNonChallengeItems.count
        } else if !filteredChallengeItems.isEmpty {
            return filteredChallengeItems.count
        } else {
            return filteredNonChallengeItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        let item : TodoModel
        if !filteredChallengeItems.isEmpty && !filteredNonChallengeItems.isEmpty{
            item = indexPath.section == 0 ? filteredChallengeItems[indexPath.row] : filteredNonChallengeItems[indexPath.row]
        } else if !filteredChallengeItems.isEmpty {
            item = filteredChallengeItems[indexPath.row]
        }else{
            item = filteredNonChallengeItems[indexPath.row]
        }
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SearchSectionHeader
        
        if !filteredChallengeItems.isEmpty && !filteredNonChallengeItems.isEmpty {
            header.sectionLabel.text = indexPath.section == 0 ? "챌린지 투두" : "일반 투두"
        } else if !filteredChallengeItems.isEmpty {
            header.sectionLabel.text = "챌린지 투두"
        } else {
            header.sectionLabel.text = "일반 투두"
        }
        header.sectionLabel.textColor = .challendarBlack60
        header.sectionLabel.font = .pretendardSemiBold(size: 14)
        
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
    }
    
    class SearchSectionHeader: UICollectionReusableView {
        let sectionLabel: UILabel = {
            let label = UILabel()
            label.font = .pretendardMedium(size: 16)
            label.textColor = .challendarBlack60
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
}
