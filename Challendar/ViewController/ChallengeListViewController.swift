//
//  ChallengeListViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

// 챌린지 투두 리스트를 보여주는 페이지
class ChallengeListViewController: BaseViewController {
    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodos: [Todo] = []         // 완료 투두
    private var incompleteTodos: [Todo] = []        // 미완료 투두
    private var upcomingTodos: [Todo] = []          // 예정 투두
    
    private var emptyMainLabel: UILabel!
    private var emptySubLabel: UILabel!
    private var emptyImage: UIImageView!
    
    private var dateView: UIView!
    private var dayLabel: UILabel!
    private var yearLabel: UILabel!
    private var collectionView: UICollectionView!
    private var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
        configureTitleNavigationBar(title: "챌린지 리스트")
        loadData()
    }
    
    override func configureUI() {
        super.configureUI()
        setupEmptyStateViews()
        setupCollectionView()
        setupDateView()
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        setupLayout()
        setupEmptyStateConstraints()
    }
    
    override func configureNotificationCenter() {
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataChanged(_:)),
            name: NSNotification.Name("CoreDataChanged"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkBoxTapped),
            name: NSNotification.Name("ButtonTapped"),
            object: nil
        )
    }
    
    // CoreData가 변경되었을 때 데이터를 다시 로드
    @objc func coreDataChanged(_ notification: Notification) {
        loadData()
    }

    // 체크박스가 탭되었을 때마다 모든 챌린지가 완료되었는지 확인
    @objc func checkBoxTapped(){
        checkIfAllChallengesCompleted()
    }

    // CoreData에서 투두 리스트를 가져와서 필터링, 디폴트로 최신순 정렬
    private func loadData() {
        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        updateEmptyStateVisibility()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyStateVisibility()
        }
    }
    
    private func setupLayout() {
        dateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // 상단 날짜 뷰
    private func setupDateView() {
        dateView = UIView()
        dateView.backgroundColor = .clear
        view.addSubview(dateView)
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            dateFormatter.locale = Locale.init(identifier: "ko_KR")
            let todayString = dateFormatter.string(from: Date())
        
         let yearFormatter = DateFormatter()
         yearFormatter.dateFormat = "yyyy년"
         let yearString = yearFormatter.string(from: Date())
            
        
        dayLabel = UILabel()
        dayLabel.text = todayString
        dayLabel.font = .pretendardSemiBold(size: 16)
        dayLabel.textColor = .secondary200
        dateView.addSubview(dayLabel)
        
        yearLabel = UILabel()
        yearLabel.text = yearString
        yearLabel.font = .pretendardSemiBold(size: 16)
        yearLabel.textColor = .secondary800
        dateView.addSubview(yearLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dayLabel.snp.trailing).offset(7)
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "enabledCell")
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 83, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .absolute(75))
        }
    }
    
    // 투두 필터링: 투두 리스트를 완료, 미완료, 예정으로 필터링함
    private func filterTodos() {
        let today = Date()
        let filteredItems = CoreDataManager.shared.fetchTodos().filter { // endDate가 오늘이거나 과거인 도전 항목
            $0.isChallenge && ($0.endDate ?? today) >= today
        }
        // 왼료 도전
        completedTodos = filteredItems.filter {
            ($0.todayCompleted(date: today) ?? false)
        }
        // 미완료 도전
        incompleteTodos = filteredItems.filter {
            guard let startDate = $0.startDate else { return false }
            return !($0.todayCompleted(date: today) ?? false) && startDate <= today
        }
        // 도전 예정 항목
        upcomingTodos = filteredItems.filter {
            guard let startDate = $0.startDate else { return false }
            return startDate > today
        }
    }
    
    // 최신순 정렬: 필터링된 항목들을 startDate 순으로 내림차순 정렬
    private func sortByRecentStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        upcomingTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
    }
    
    // 등록순 정렬: 필터링된 항목들을 startDate 순으로 오름차순 정렬
    private func sortByOldestStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
        upcomingTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
    }
    
    // 기한 임박 정렬: 필터링된 항목들을 endDate 순으로 오름차순 정렬
    private func sortByNearestEndDate() {
        completedTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
        incompleteTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
        upcomingTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
    }
    
    // 리스트가 없는 상태 UI
    private func setupEmptyStateViews() {
        emptyMainLabel = UILabel()
        emptyMainLabel.text = "리스트가 없어요..."
        emptyMainLabel.font = .pretendardSemiBold(size: 20)
        emptyMainLabel.textColor = .challendarWhite
        view.addSubview(emptyMainLabel)
        
        emptySubLabel = UILabel()
        emptySubLabel.text = "추가 버튼을 눌러 등록해주세요"
        emptySubLabel.font = .pretendardMedium(size: 13)
        emptySubLabel.textColor = .secondary500
        view.addSubview(emptySubLabel)
        
        emptyImage = UIImageView()
        emptyImage.image = UIImage(named: "bullseye")
        view.addSubview(emptyImage)
    }
    
    // 리스트가 없는 상태 UI 제약조건
    private func setupEmptyStateConstraints() {
        emptyMainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emptySubLabel.snp.top).offset(-8)
        }
        
        emptySubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emptyImage.snp.top).offset(-32)
        }
        
        emptyImage.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // 리스트가 있을 경우 UI 숨김
    private func updateEmptyStateVisibility() {
        let isEmpty = completedTodos.isEmpty && incompleteTodos.isEmpty && upcomingTodos.isEmpty
        emptyMainLabel.isHidden = !isEmpty
        emptySubLabel.isHidden = !isEmpty
        emptyImage.isHidden = !isEmpty
    }
    
    // 모든 챌린지 완료 확인: 모든 챌린지가 완료되었으면 successViewController 표시
    private func checkIfAllChallengesCompleted() {
        if incompleteTodos.isEmpty {
            let successViewController = ChallengeSuccessViewController()
            successViewController.modalPresentationStyle = .fullScreen
            successViewController.modalTransitionStyle = .crossDissolve
            self.present(successViewController, animated: true, completion: nil)
        }
    }
}

extension ChallengeListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 값이 없는 섹션을 제외한 섹션의 수를 구함
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [completedTodos, incompleteTodos, upcomingTodos].filter { !$0.isEmpty }.count
    }
    
    // 각 섹션별 항목 수를 구함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItemCount(for: section)
    }
    
    // 각 섹션별 셀 설정: 각 셀을 필터된 아이템의 값에 따라 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todo = getTodoItem(for: indexPath)
        let today = Date()
        
        if let startDate = todo.startDate, startDate > today {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enabledCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: todo)
            cell.contentView.alpha = 0.2
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: todo)
            cell.delegate = self
            return cell
        }
    }
    
    // indexPath에 해당하는 섹션 헤더 dequeue, getSectionHeaderTitle 호출해서 섹션헤더 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        header.sectionLabel.text = getSectionHeaderTitle(for: indexPath.section)
        header.section = indexPath.section
        return header
    }
    
    // 각 섹션별 항목 수를 구함
    private func getTodoItemCount(for section: Int) -> Int {
        switch getSectionType(for: section) {
        case .completed:
            return completedTodos.count
        case .incomplete:
            return incompleteTodos.count
        case .upcoming:
            return upcomingTodos.count
        }
    }
    
    // indexPath에 해당하는 투두 아이템 값 구함
    private func getTodoItem(for indexPath: IndexPath) -> Todo {
        switch getSectionType(for: indexPath.section) {
        case .completed:
            return completedTodos[indexPath.item]
        case .incomplete:
            return incompleteTodos[indexPath.item]
        case .upcoming:
            return upcomingTodos[indexPath.item]
        }
    }
    
    // 각 아이템을 선택했을 때 detailVC 표시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let todo = getTodoItem(for: indexPath)
        let detailVC = ChallengeListDetailViewController()
        detailVC.newTodo = todo
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private enum SectionType {
        case completed, incomplete, upcoming
    }
    
    // 각 인덱스에 해당하는 섹션 타입 반환
    private func getSectionType(for section: Int) -> SectionType {
        var index = 0
        
        if !incompleteTodos.isEmpty {
            if index == section { return .incomplete }
            index += 1
        }
        if !completedTodos.isEmpty {
            if index == section { return .completed }
            index += 1
        }
        if !upcomingTodos.isEmpty {
            if index == section { return .upcoming }
        }
        print("Invalid section: \(section)")
        return .incomplete
    }
    
    // 각 섹션의 헤더 제목 구함
    private func getSectionHeaderTitle(for section: Int) -> String {
        switch getSectionType(for: section) {
        case .completed:
            return "오늘 완료된 목록"
        case .incomplete:
            return "지금 도전 중!"
        case .upcoming:
            return "도전 예정 목록"
        }
    }
}

extension ChallengeListViewController : ChallengeCollectionViewCellDelegate {
    
    func editContainerTapped(in cell: ChallengeCollectionViewCell) {
        let editVC = EditTodoViewController()
        editVC.todoId = cell.todoItem?.id
        editVC.modalTransitionStyle = .coverVertical
        editVC.modalPresentationStyle = .fullScreen
        let navi = UINavigationController(rootViewController: editVC)
        navi.modalPresentationStyle = .overFullScreen
        self.present(navi, animated: true, completion: nil)
    }
}
