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
    private var filteredChallengeItems: [Todo] = []  // 챌린지 투두
    private var filteredNonChallengeItems: [Todo] = []  // 챌린지가 아닌 투두 (계획, 할 일)
    private var filteredNoDeadlineItems: [Todo] = []    // 기한 없는 투두
    private var filteredCompletedItems: [Todo] = []     // 완료된 투두
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    // 검색값에 해당하는 투두가 없는 경우의 UI
    private var emptyMainLabel: UILabel!
    private var emptyImage: UIImageView!
    
    var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var customCancelButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        setupLayout()
        setupEmptyStateConstraints()
    }
    
    override func configureNotificationCenter() {
        // CoreData가 변경되었을 때 데이터를 다시 로드하는 노티
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataChanged(_:)),
            name: NSNotification.Name("CoreDataChanged"),
            object: nil
        )
    }
    // CoreData가 변경되었을 때 데이터를 다시 로드
    @objc func coreDataChanged(_ notification: Notification) {
        DispatchQueue.main.async{
            self.reloadData()
        }
        
    }
    
    // 컬렉션 뷰의 제약 조건
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
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
        collectionView.register(TodoCalendarViewCell.self, forCellWithReuseIdentifier: "calendarCell")
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    // 컴포지셔널 레이아웃 호출
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .estimated(75))
        }
    }
    
    // 데이터 리로드: 검색텍스트로 CoreData에서 투두 항목을 다시 가져와서 필터링
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
    
    // 서치바 UI 설정
    func searchBarConfigure() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "도전, 할 일, 계획 검색"
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.showsCancelButton = false
        searchBar.tintColor = UIColor.label
        
        searchBar.searchTextField.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        searchBarTextFieldConfigure()
        self.navigationItem.titleView = searchBar
    }
    
    @objc func cancelButtonTap() {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 서치바 타이핑할 때 취소 버튼 표시
        searchBar.setShowsCancelButton(true, animated: false)
        //        navigationItem.rightBarButtonItem = customCancelButton
        updateSearchTextFieldConstraints(showingCancelButton: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 서치바 타이핑 안할 때 취소 버튼 숨김
        searchBar.setShowsCancelButton(false, animated: false)
        //        navigationItem.rightBarButtonItem = nil
        updateSearchTextFieldConstraints(showingCancelButton: false)
    }
    
    // 서치바 TextField 커스텀
    private func searchBarTextFieldConfigure() {
        searchBar.searchTextField.backgroundColor = .secondary850
        searchBar.searchTextField.font = .pretendardMedium(size: 18)
        searchBar.searchTextField.layer.borderColor = UIColor(white: 1, alpha: 0.02).cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.tintColor = .challendarGreen200
        searchBar.searchTextField.textColor = .challendarWhite
        
        if let placeholderText = searchBar.placeholder {
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    NSAttributedString.Key.font: UIFont.pretendardRegular(size: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.secondary800
                ]
            )
        }
        setLeftImage(UIImage.search0, for: searchBar.searchTextField)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pretendardSemiBold(size: 16)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLeftImage(_ image: UIImage, for textField: UITextField) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.tintColor = .secondary600
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 22))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    // 서치바 취소 버튼 상황별 제약조건
    private func updateSearchTextFieldConstraints(showingCancelButton: Bool) {
        let trailingConstant: CGFloat = showingCancelButton ? -64 : -16
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.searchTextField.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(trailingConstant)
            }
        })
    }
    
    // 검색값에 해당하는 투두가 없는 경우의 UI 요소
    private func setupEmptyStateViews() {
        emptyMainLabel = UILabel()
        emptyMainLabel.text = "검색 결과가 없어요..."
        emptyMainLabel.font = .pretendardSemiBold(size: 20)
        emptyMainLabel.textColor = .secondary700
        view.addSubview(emptyMainLabel)
        
        emptyImage = UIImageView()
        emptyImage.image = .surprisedFace
        view.addSubview(emptyImage)
    }
    
    // 검색값에 해당하는 투두가 없는 경우의 UI 제약 조건
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
    
    // 검색값에 해당하는 투두가 없는 경우를 구분 및 업데이트
    private func updateEmptyState(hasResults: Bool, searchText: String) {
        if searchText.isEmpty {
            emptyMainLabel.isHidden = true
            emptyImage.isHidden = true
        } else {
            emptyMainLabel.isHidden = hasResults
            emptyImage.isHidden = hasResults
        }
    }
    
    // 검색값에 해당하는 투두가 없는 경우는 빈 배열, 아닌 경우 각 기준에 따라 아이템 필터링, 최신순으로 정렬
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredChallengeItems = []
            filteredNonChallengeItems = []
            filteredNoDeadlineItems = []
            filteredCompletedItems = []
        } else {
            filteredChallengeItems = items.filter { $0.isChallenge && !($0.todayCompleted() ?? false) && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNonChallengeItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate != nil && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredNoDeadlineItems = items.filter { !$0.isChallenge && !($0.todayCompleted() ?? false) && $0.endDate == nil && !$0.iscompleted && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            filteredCompletedItems = items.filter { ($0.todayCompleted() ?? false || $0.iscompleted) && $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        }
        sortByRecentStartDate()
        updateEmptyState(hasResults: !filteredChallengeItems.isEmpty || !filteredNonChallengeItems.isEmpty || !filteredNoDeadlineItems.isEmpty || !filteredCompletedItems.isEmpty, searchText: searchText)
        self.collectionView.reloadData()
    }
    
    // 최신순 정렬: 필터링된 항목들을 startDate 순으로 정렬
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
    
    // 완료 상태 비교: 두 투두 항목의 완료 상태를 비교)
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
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 값이 없는 섹션을 제외한 섹션의 수를 구함
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [filteredChallengeItems, filteredNonChallengeItems, filteredNoDeadlineItems, filteredCompletedItems].filter { !$0.isEmpty }.count
    }
    
    // 각 섹션별 항목 수를 구함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItem(for: section).count
    }
    
    // 각 섹션별 셀 설정: 각 셀을 필터된 아이템의 값에 따라 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = getTodoItem(for: indexPath.section)[indexPath.row]
        let today = Date()
        
        // 도전 예정 항목 셀
        if let startDate = item.startDate, item.isChallenge == true, let endDate = item.endDate, !today.isBetween(startDate, endDate) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: item)
            cell.contentView.alpha = 0.2
            cell.isUserInteractionEnabled = false
            return cell
        } else if item.isChallenge {
            // 지금 도전 중 항목 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: item)
            return cell
            // 계획 예정 항목 셀
        } else if let startDate = item.startDate, item.isChallenge == false, let endDate = item.endDate, !today.isBetween(startDate, endDate) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! TodoCalendarViewCell
            cell.configure(with: item, date: today)
            cell.contentView.alpha = 0.2
            cell.isUserInteractionEnabled = false
            return cell
        } else if item.endDate == nil {
            // 할 일 항목 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TodoCollectionViewCell
            cell.configure(with: item)
            return cell
        } else {
            // 계획 항목 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! TodoCalendarViewCell
            cell.configure(with: item, date: today)
            cell.contentView.alpha = 1.0
            return cell
        }
    }
    
    // 섹션 헤더 메소드 호출
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        header.sectionLabel.text = getSectionHeaderTitle(for: indexPath.section)
        return header
    }
    
    // 항목 선택시 해당 투두의 완료/ 미완료를 토글하고 해당 투두 값에 업데이트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = getTodoItem(for: indexPath.section)[indexPath.row]
        
        item.toggleTodaysCompletedState()
        
        CoreDataManager.shared.updateTodoById(id: item.id!, newCompleted: item.completed)
        
        if let searchText = searchBar.text {
            filterItems(with: searchText)
        }
        
        collectionView.reloadData()
    }
    
    // 각 섹션의 항목들 구함
    private func getTodoItem(for section: Int) -> [Todo] {
        let nonEmptySections = [filteredChallengeItems, filteredNonChallengeItems, filteredNoDeadlineItems, filteredCompletedItems].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].element
    }
    
    // 각 인덱스 값에 해당하는 섹션의 헤더 제목을 반환
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
    // 검색어가 변경될 때마다 필터링하게끔
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        if let tabBarController = self.tabBarController as? TabBarViewController {
        //            tabBarController.goToPreviousTab()
        //        }
        searchBar.resignFirstResponder()
    }
}
