//
//  SearchViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

// 투두 검색 기능이 있는 페이지
class SearchViewController: BaseViewController {
    
    private var items: [Todo] = CoreDataManager.shared.fetchTodos()
    private var filteredChallengeItems: [Todo] = []
    private var filteredNonChallengeItems: [Todo] = []
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var customCancelButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData() // 데이터 다시 로드
        if let searchText = searchBar.text, !searchText.isEmpty {
            filterItems(with: searchText)
        } else {
            filterItems(with: "")
        }
        self.collectionView.reloadData() // 데이터 리로드
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterItems(with: "")
        reloadData()
    }
    
    override func configureUI() {
        super.configureUI()
        configureBackground()
        searchBarConfigure()
        setupCollectionView()
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        setupLayout()
    }
    
    override func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataChanged(_:)),
            name: NSNotification.Name("CoreDataChanged"),
            object: nil
        )
    }
    
    @objc func coreDataChanged(_ notification: Notification) {
        reloadData() // 데이터 다시 로드
        if let searchText = searchBar.text, !searchText.isEmpty {
            filterItems(with: searchText)
        } else {
            filterItems(with: "")
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Empty")
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        // 챌린지 투두용 셀 등록
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "challengeCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .estimated(75))
        }
    }
    
    private func reloadData() {
        self.items = CoreDataManager.shared.fetchTodos()
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
        cancelText.textColor = .challendarWhite
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
        searchTextField.textColor = .challendarWhite
        
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
        imageView.frame = CGRect(x: 8, y: 0, width: 24, height: 24)
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
        self.items = CoreDataManager.shared.fetchTodos()
        if searchText.isEmpty {
            filteredChallengeItems = items.filter { $0.isChallenge == true }
            filteredNonChallengeItems = items.filter { $0.isChallenge == false }
        } else {
            filteredChallengeItems = items.filter { $0.isChallenge == true && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNonChallengeItems = items.filter { $0.isChallenge == false && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        }
        
        // 기본 정렬 -> 최신순 (startDate 기준 내림차순)
        sortByRecentStartDate()
        reloadData() // 필터링 후 데이터 리로드
    }

    // 최신순
    private func sortByRecentStartDate() {
        filteredChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast)
        }
        filteredNonChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast)
        }
    }

    // 등록순
    private func sortByOldestStartDate() {
        filteredChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast)
        }
        filteredNonChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast)
        }
    }

    // 기한 임박
    private func sortByNearestEndDate() {
        filteredChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture)
        }
        filteredNonChallengeItems.sort {
            let completedComparison = compareCompleted($0, $1)
            if completedComparison != .orderedSame {
                return completedComparison == .orderedAscending
            }
            return ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture)
        }
    }

    private func compareCompleted(_ todo1: Todo, _ todo2: Todo) -> ComparisonResult {
        let completed1 = todo1.todayCompleted() ?? false
        let completed2 = todo2.todayCompleted() ?? false
        
        if completed1 && !completed2 {
            return .orderedDescending
        } else if !completed1 && completed2 {
            return .orderedAscending
        } else {
            return .orderedSame
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 비어있지 않은 배열의 수 반환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [filteredChallengeItems, filteredNonChallengeItems].filter { !$0.isEmpty }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItem(for: section).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = getTodoItem(for: indexPath.section)[indexPath.row]
        let today = Date()
        
        if let startDate = item.startDate, let endDate = item.endDate, !today.isBetween(startDate, endDate) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: item)
            cell.contentView.alpha = 0.2 // 불투명도 20%로 설정
            cell.isUserInteractionEnabled = true
            return cell
        } else if item.isChallenge {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        header.sectionLabel.text = getSectionHeaderTitle(for: indexPath.section)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.item].toggleTodaysCompletedState()
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
    
    // 각 섹션 투두 항목들 반환
    private func getTodoItem(for section: Int) -> [Todo] {
        let nonEmptySections = [filteredChallengeItems, filteredNonChallengeItems].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].element
    }
    
    // 각 섹션 헤더 반환
    private func getSectionHeaderTitle(for section: Int) -> String {
        let nonEmptySections = [filteredChallengeItems, filteredNonChallengeItems].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].offset == 0 ? "챌린지 투두" : "일반 투두"
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
    }
}
