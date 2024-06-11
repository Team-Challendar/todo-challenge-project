//  ChallengeListViewController.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
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
    private var collectionView: UICollectionView!
    private var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
        filterTodos()
        configureTitleNavigationBar(title: "챌린지 리스트")
        updateEmptyStateVisibility()
        sortByRecentStartDate()     // 기본 정렬 -> 최신순 (startDate 기준 내림차순)
    }
    
    override func configureUI() {
        super.configureUI()
        setupEmptyStateViews()
        setupCollectionView()
        setupResetButton()
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
    }
    
    @objc func coreDataChanged(_ notification: Notification) {
        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyStateVisibility()
        }
    }
    
    // 레이아웃 설정
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    // 임시 리셋버튼
    private func setupResetButton() {
        resetBtn = UIButton(type: .system)
        resetBtn.setTitle("Reset All", for: .normal)
        resetBtn.setTitleColor(.white, for: .normal)
        resetBtn.backgroundColor = .red
        resetBtn.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        view.addSubview(resetBtn)

        resetBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc private func resetButtonTapped() {
        CoreDataManager.shared.deleteAllTodos()
        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyStateVisibility()
        }
    }

    // 컬렉션뷰 설정
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "enabledCell")
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    // 컬렉션뷰 레이아웃 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .absolute(75))
        }
    }
    
    // 오늘 기준 투두 필터링
    private func filterTodos() {
        let today = Date()
        let filteredItems = CoreDataManager.shared.fetchTodos().filter {
            $0.isChallenge && ($0.endDate ?? today) >= today
        }
        
        completedTodos = filteredItems.filter {
            ($0.todayCompleted(date: today) ?? false)
        }
        
        incompleteTodos = filteredItems.filter {
            guard let startDate = $0.startDate else { return false }
            return !($0.todayCompleted(date: today) ?? false) && startDate <= today
        }
        
        upcomingTodos = filteredItems.filter {
            guard let startDate = $0.startDate else { return false }
            return startDate > today
        }
    }
    
    // 최신순
    private func sortByRecentStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        upcomingTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
    }
    
    // 등록순
    private func sortByOldestStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
        upcomingTodos.sort { ($0.startDate ?? Date.distantPast) < ($1.startDate ?? Date.distantPast) }
    }
    
    // 기한 임박
    private func sortByNearestEndDate() {
        completedTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
        incompleteTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
        upcomingTodos.sort { ($0.endDate ?? Date.distantFuture) < ($1.endDate ?? Date.distantFuture) }
    }
    
    // 비어있는 상태 UI 설정
    private func setupEmptyStateViews() {
        emptyMainLabel = UILabel()
        emptyMainLabel.text = "리스트가 없어요..."
        emptyMainLabel.font = .pretendardSemiBold(size: 20)
        emptyMainLabel.textColor = .challendarWhite
        view.addSubview(emptyMainLabel)
        
        emptySubLabel = UILabel()
        emptySubLabel.text = "작성하기 버튼을 눌러 등록해주세요."
        emptySubLabel.font = .pretendardMedium(size: 13)
        emptySubLabel.textColor = .challendarGrey50
        view.addSubview(emptySubLabel)
        
         emptyImage = UIImageView()
         emptyImage.image = UIImage(named: "SurprisedFace")
         view.addSubview(emptyImage)
    }
    
    // 비어있는 상태 제약 조건 설정
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
    
    // 비어있는 상태 업데이트
    private func updateEmptyStateVisibility() {
        let isEmpty = completedTodos.isEmpty && incompleteTodos.isEmpty && upcomingTodos.isEmpty
        emptyMainLabel.isHidden = !isEmpty
        emptySubLabel.isHidden = !isEmpty
        emptyImage.isHidden = !isEmpty
    }

}

extension ChallengeListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 비어있지 않은 배열의 수 반환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [completedTodos, incompleteTodos, upcomingTodos].filter { !$0.isEmpty }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItemCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todo = getTodoItem(for: indexPath)
        let today = Date()
        
        if let startDate = todo.startDate, startDate > today {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enabledCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: todo)
            cell.contentView.alpha = 0.2 // 불투명도 20%로 설정
            cell.isUserInteractionEnabled = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: todo)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        header.sectionLabel.text = getSectionHeaderTitle(for: indexPath.section)
        header.section = indexPath.section
        header.delegate = self

        // 섹션에 값이 있는 경우 지우기 버튼 표시
        if getTodoItemCount(for: indexPath.section) > 0 {
            header.showDeleteButton()
        } else {
            header.hideDeleteButton()
        }

        return header
    }
    
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
    
    private enum SectionType {
        case completed, incomplete, upcoming
    }
    
    // 섹션 인덱스로 각 섹션 타입 반환
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
        return .incomplete // 기본값을 반환하거나 적절한 오류 처리를 합니다.
    }
    
    // 각 섹션 헤더 반환
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

extension ChallengeListViewController: SectionHeaderDelegate {
    func didTapDeleteButton(in section: Int) {
        let todosToDelete: [Todo]
        switch getSectionType(for: section) {
        case .completed:
            todosToDelete = completedTodos
        case .incomplete:
            todosToDelete = incompleteTodos
        case .upcoming:
            todosToDelete = upcomingTodos
        }

        for todo in todosToDelete {
            CoreDataManager.shared.deleteTodoById(id: todo.id!)
        }

        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyStateVisibility()
        }
    }
}
