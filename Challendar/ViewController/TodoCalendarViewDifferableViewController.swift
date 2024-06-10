import UIKit

class TodoCalendarViewDifferableViewController: BaseViewController {
    var calendarView = TodoCalendarView()
    private let periodBtnView = PeriodPickerButtonView() // 기간피커
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodo : [Todo] = []
    private var inCompletedTodo: [Todo] = []
    var days : [Day] = []
    var changedMonth : Date?
    var currentDate : Date?
    private var collectionView: UICollectionView!
    private var isFirstSectionExpanded = true
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Todo>!
    
    override func viewDidLoad() {
        configureCollectionView()
        configureCalendarView()
        super.viewDidLoad()
        filterTodoitems(date: currentDate ?? Date())
        configureFloatingButton()
        configureNav()
        configureDataSource()
    }
    override func configureNotificationCenter(){
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name: NSNotification.Name("date"), object: currentDate)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
    }
    
    override func configureUI() {
        super.configureUI()
        calendarView.snp.makeConstraints{
            $0.height.equalTo(initialCalendarHeight)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureNav(){
        let button = configureCalendarButtonNavigationBar(title: "월간")
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
    }
    
    private func configureCalendarView(){
        self.view.addSubview(calendarView)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TodoCalendarViewCell.self, forCellWithReuseIdentifier: TodoCalendarViewCell.identifier)
        collectionView.register(ChallengeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .estimated(75))
        }
    }

    private func filterTodoitems(date: Date = Date()){
        self.todoItems = todoItems.filter({
            $0.startDate != nil && $0.isChallenge == false
        })
        completedTodo = todoItems.filter({
            $0.todayCompleted(date: date) == true
        })
        inCompletedTodo = todoItems.filter({
            $0.todayCompleted(date: date) == false
        })
        days = Day.generateDaysForMonth(date: date, todos: self.todoItems)
        calendarView.dayModelForCurrentPage = days
        calendarView.calendar.reloadData()
    }
    
    // 데이터 소스 설정
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Todo>(collectionView: collectionView) { (collectionView, indexPath, todo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
            cell.configure(with: todo, date: self.currentDate ?? Date())
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ChallengeSectionHeader
            switch indexPath.section {
            case 0:
                header.sectionLabel.text = "할일"
            case 1:
                header.sectionLabel.text = "완료된 투두"
            default:
                header.sectionLabel.text = "챌린지 투두"
            }
            return header
        }
        updateDataSource()
    }

    // 데이터 업데이트
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
        snapshot.appendSections([.incomplete, .complete])
        snapshot.appendItems(inCompletedTodo, toSection: .incomplete)
        snapshot.appendItems(completedTodo, toSection: .complete)
            
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func dateChanged(notification : Notification){
        guard let date = notification.object as? Date else {return}
        self.currentDate = date
        self.filterTodoitems(date: self.currentDate!)
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    
    @objc func coreDataUpdated(){
        todoItems = CoreDataManager.shared.fetchTodos()
        self.filterTodoitems(date:  self.currentDate ?? Date())
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    
    @objc func titleTouched() {}
}

// Section 정의
extension TodoCalendarViewDifferableViewController {
    enum Section {
        case incomplete
        case complete
    }
}


extension TodoCalendarViewDifferableViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    // collectionView(_:numberOfItemsInSection:) 및 collectionView(_:cellForItemAt:) 메서드는 삭제되었습니다.
    // 이제 dataSource에 의해 데이터를 관리하므로 필요하지 않습니다.
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if translation.y > 0 {
            // 아래로 스크롤
            self.calendarView.calendar.setScope(.month, animated: true)
            UIView.animate(withDuration: 0.5) {
                self.calendarView.snp.updateConstraints {
                    $0.height.equalTo(maxCalendarHeight)
                }
                self.view.layoutIfNeeded()
            }
            
        } else if translation.y < 0 {
            // 위로 스크롤
            UIView.animate(withDuration: 0.5) {
                self.calendarView.snp.updateConstraints {
                    $0.height.equalTo(minCalendarHeight)
                }
                self.view.layoutIfNeeded()
            }
            self.calendarView.calendar.setScope(.week, animated: true)
        }
    }
}
