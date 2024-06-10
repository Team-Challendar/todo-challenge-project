//
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
//    private var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
        filterTodos()
        updateEmptyStateVisibility()
        sortByRecentStartDate()     // 기본 정렬 -> 최신순 (startDate 기준 내림차순)
    }
    
    override func configureUI() {
        super.configureUI()
        setupEmptyStateViews()
        setupCollectionView()
//        setupResetButton()
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
//    private func setupResetButton() {
//        resetBtn = UIButton(type: .system)
//        resetBtn.setTitle("Reset All", for: .normal)
//        resetBtn.setTitleColor(.white, for: .normal)
//        resetBtn.backgroundColor = .red
//        resetBtn.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
//        view.addSubview(resetBtn)
//        
//        resetBtn.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalTo(50)
//        }
//    }
    
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
        emptyMainLabel.textColor = .challendarWhite100
        view.addSubview(emptyMainLabel)
        
        emptySubLabel = UILabel()
        emptySubLabel.text = "작성하기 버튼을 눌러 등록해주세요."
        emptySubLabel.font = .pretendardMedium(size: 13)
        emptySubLabel.textColor = .challendarGrey50
        view.addSubview(emptySubLabel)
        
        // If you want to use the emptyImage
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
    
    // 비어있는 상태 가시성 업데이트
    private func updateEmptyStateVisibility() {
        let isEmpty = todoItems.isEmpty
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
        switch getSectionType(for: section) {
        case .completed:
            return completedTodos.count
        case .incomplete:
            return incompleteTodos.count
        case .upcoming:
            return upcomingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todo = getTodoItem(for: indexPath)
        let today = Date()
        
        if let startDate = todo.startDate, startDate > today {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enabledCell", for: indexPath) as! SearchCollectionViewCell
            cell.configure(with: todo)
            cell.contentView.alpha = 0.2 // 불투명도 20%로 설정
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
        return header
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
    
    // 각 섹션 투두 항목들 반환
    private func getTodoItem(for indexPath: IndexPath) -> Todo {
        switch getSectionType(for: indexPath.section) {
        case .completed:
            guard completedTodos.indices.contains(indexPath.item) else {
                print("Invalid indexPath: \(indexPath)")
                return Todo() // 기본값을 반환하거나 적절한 오류 처리를 합니다.
            }
            return completedTodos[indexPath.item]
        case .incomplete:
            guard incompleteTodos.indices.contains(indexPath.item) else {
                print("Invalid indexPath: \(indexPath)")
                return Todo() // 기본값을 반환하거나 적절한 오류 처리를 합니다.
            }
            return incompleteTodos[indexPath.item]
        case .upcoming:
            guard upcomingTodos.indices.contains(indexPath.item) else {
                print("Invalid indexPath: \(indexPath)")
                return Todo() // 기본값을 반환하거나 적절한 오류 처리를 합니다.
            }
            return upcomingTodos[indexPath.item]
        }
    }
    
    // 각 섹션 헤더 반환
    private func getSectionHeaderTitle(for section: Int) -> String {
        switch getSectionType(for: section) {
        case .completed:
            return "오늘 완료된 목록"
        case .incomplete:
            return "지금 도전 중!"
        case .upcoming:
            return "예정된 목록"
        }
    }
}

class ChallengeSectionHeader: UICollectionReusableView {
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
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
