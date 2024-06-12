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
    private var filteredNoDeadlineItems: [Todo] = []
    private var filteredCompletedItems: [Todo] = []
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    private var emptyMainLabel: UILabel!
    private var emptyImage: UIImageView!
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var customCancelButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyMainLabel.isHidden = true
        emptyImage.isHidden = true
    }
    
    override func configureUI() {
        super.configureUI()
        setupEmptyStateViews()
        configureBackground()
        searchBarConfigure()
        setupCollectionView()
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        setupLayout()
        setupEmptyStateConstraints()
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
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "challengeCell")
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
        if let searchText = searchBar.text, !searchText.isEmpty {
            filterItems(with: searchText)
        } else {
            filteredChallengeItems = []
            filteredNonChallengeItems = []
            filteredNoDeadlineItems = []
            filteredCompletedItems = []
            updateEmptyState(hasResults: true, searchText: "")
        }
        self.collectionView.reloadData()
    }
    
    private func searchBarConfigure() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력해주세요"
        navigationItem.titleView = searchBar
        searchBarTextFieldConfigure()
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTap))
        cancelBtn.addGestureRecognizer(tapGesture)
        
        customCancelButton = UIBarButtonItem(customView: cancelBtn)
    }
    
    @objc func cancelButtonTap() {
//        searchBar.setShowsCancelButton(false, animated: true)
//        navigationItem.rightBarButtonItem = nil
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        filterItems(with: "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.rightBarButtonItem = customCancelButton
        updateSearchTextFieldConstraints(showingCancelButton: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.rightBarButtonItem = nil
        updateSearchTextFieldConstraints(showingCancelButton: false)
    }
    
    private func searchBarTextFieldConfigure() {
        guard let searchTextField = searchBar.value(forKey: "searchField") as? UITextField else {
            return
        }
        
        searchTextField.backgroundColor = .secondary800
        searchTextField.font = .pretendardMedium(size: 18)
        searchTextField.layer.borderColor = UIColor(white: 1, alpha: 0.02).cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 12
        searchTextField.clipsToBounds = true
        searchTextField.tintColor = .secondary800
        searchTextField.textColor = .challendarWhite
        
        if let placeholderText = searchBar.placeholder {
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    NSAttributedString.Key.font: UIFont.pretendardRegular(size: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.secondary600
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
        imageView.tintColor = .secondary600
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
    
    // 비어있는 상태 UI 설정
    private func setupEmptyStateViews() {
        emptyMainLabel = UILabel()
        emptyMainLabel.text = "검색 결과가 없어요..."
        emptyMainLabel.font = .pretendardSemiBold(size: 20)
        emptyMainLabel.textColor = .secondary700
        view.addSubview(emptyMainLabel)
        
        emptyImage = UIImageView()
        emptyImage.image = UIImage(named: "SurprisedFace")
        view.addSubview(emptyImage)
    }
    
    private func setupEmptyStateConstraints() {
        emptyMainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emptyImage.snp.top).offset(-32)
        }
        
        emptyImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateEmptyState(hasResults: Bool, searchText: String) {
        if searchText.isEmpty {
            emptyMainLabel.isHidden = true
            emptyImage.isHidden = true
        } else {
            emptyMainLabel.isHidden = hasResults
            emptyImage.isHidden = hasResults
        }
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredChallengeItems = []
            filteredNonChallengeItems = []
            filteredNoDeadlineItems = []
            filteredCompletedItems = []
            //            filteredChallengeItems = items.filter { $0.isChallenge && !($0.todayCompleted() ?? false) }
            //            filteredNonChallengeItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate != nil }
            //            filteredNoDeadlineItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate == nil }
            //            filteredCompletedItems = items.filter { ($0.todayCompleted() ?? false) || $0.iscompleted }
        } else {
            filteredChallengeItems = items.filter { $0.isChallenge && !($0.todayCompleted() ?? false) && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNonChallengeItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate != nil && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNoDeadlineItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate == nil && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            //            filteredCompletedItems = items.filter { ($0.todayCompleted() ?? false) || $0.iscompleted && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        }
        
        // 기본 정렬 -> 최신순 (startDate 기준 내림차순)
        sortByRecentStartDate()
        updateEmptyState(hasResults: !filteredChallengeItems.isEmpty || !filteredNonChallengeItems.isEmpty || !filteredNoDeadlineItems.isEmpty || !filteredCompletedItems.isEmpty, searchText: searchText)
        self.collectionView.reloadData() // 필터링 후 데이터 리로드
    }
    
    // 최신순
    private func sortByRecentStartDate() {
        func sortItems(_ items: inout [Todo]) {
            items.sort {
                let isBetweenDates1 = Date.isTodayBetween($0.startDate ?? Date.distantPast, $0.endDate ?? Date.distantFuture)
                let isBetweenDates2 = Date.isTodayBetween($1.startDate ?? Date.distantPast, $1.endDate ?? Date.distantFuture)
                
                if isBetweenDates1 && !isBetweenDates2 {
                    return true
                } else if !isBetweenDates1 && isBetweenDates2 {
                    return false
                }
                
                let completedComparison = compareCompleted($0, $1)
                if completedComparison != .orderedSame {
                    return completedComparison == .orderedAscending
                }
                
                return ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast)
            }
        }
        
        sortItems(&filteredChallengeItems)
        sortItems(&filteredNonChallengeItems)
        filteredNoDeadlineItems.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        filteredCompletedItems.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
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
        return [filteredChallengeItems, filteredNonChallengeItems, filteredNoDeadlineItems, filteredCompletedItems].filter { !$0.isEmpty }.count
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
            cell.isUserInteractionEnabled = false
            return cell
        } else if item.isChallenge {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: item)
            return cell
        } else if item.endDate == nil { // 기한 없는 투두
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TodoCollectionViewCell
//            cell.configure(with: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: item)
            cell.contentView.alpha = 1.0
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
    
    private func getTodoItem(for section: Int) -> [Todo] {
        let nonEmptySections = [filteredChallengeItems, filteredNonChallengeItems, filteredNoDeadlineItems, filteredCompletedItems].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].element
    }
    
    private func getSectionHeaderTitle(for section: Int) -> String {
        let nonEmptySections = [filteredChallengeItems, filteredNonChallengeItems, filteredNoDeadlineItems, filteredCompletedItems].enumerated().filter { !$0.element.isEmpty }
        switch nonEmptySections[section].offset {
        case 0:
            return "도전"
        case 1:
            return "계획"
        case 2:
            return "할 일"
        case 3:
            return "완료"
        default:
            return ""
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
    }
}
