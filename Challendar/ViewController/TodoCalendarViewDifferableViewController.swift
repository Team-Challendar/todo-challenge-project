import UIKit

class TodoCalendarViewDifferableViewController: BaseViewController {
    var calendarView = TodoCalendarView()
    private let periodBtnView = PeriodPickerButtonView() // 기간피커
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodo: [Todo] = []
    private var inCompletedTodo: [Todo] = []
    var days: [Day] = []
    var changedMonth: Date?
    var currentDate: Date?
    private var collectionView: UICollectionView!
    private var isPickerExpanded = false
    var currentState : currentCalendar = .month
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        configureCollectionView()
        super.viewDidLoad()
        filterTodoitems(date: currentDate ?? Date())
        configureFloatingButton()
        configureNav()
        configureDataSource()
    }
    
    override func configureNotificationCenter() {
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name: NSNotification.Name("date"), object: currentDate)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
    }
    
    override func configureUI() {
        super.configureUI()
        periodBtnView.delegate = self
    }
    
    override func configureConstraint() {
        [collectionView!, periodBtnView].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        periodBtnView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).priority(999)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(131)
            $0.height.equalTo(0)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    func configureNav() {
        let button = configureCalendarButtonNavigationBar(title: "월간")
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
    }
    
    private func configureCalendarView() {
        self.view.addSubview(calendarView)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TodoCalendarCell.self, forCellWithReuseIdentifier: TodoCalendarCell.identifier)
        collectionView.register(TodoCalendarViewCell.self, forCellWithReuseIdentifier: TodoCalendarViewCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        
    }
    
    private func filterTodoitems(date: Date = Date()) {
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
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .calendarItem(let day):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarCell.identifier, for: indexPath) as! TodoCalendarCell
                cell.configureCalenderView(days: day)
                return cell
            case .incompleteItem(let todo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
                cell.configure(with: todo, date: self.currentDate ?? Date())
                return cell
            case .completeItem(let todo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
                cell.configure(with: todo, date: self.currentDate ?? Date())
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            switch indexPath.section {
            case 1:
                header.sectionLabel.text = "할일"
            case 2:
                header.sectionLabel.text = "완료된 투두"
            default:
                header.sectionLabel.text = ""
            }
            return header
        }
        updateDataSource()
    }
    
    // 데이터 업데이트
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.calendar, .incomplete, .complete])
        snapshot.appendItems([days].map { .calendarItem($0) }, toSection: .calendar)
        snapshot.appendItems(inCompletedTodo.map { .incompleteItem($0) }, toSection: .incomplete)
        snapshot.appendItems(completedTodo.map { .completeItem($0) }, toSection: .complete)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func dateChanged(notification: Notification) {
        todoItems = CoreDataManager.shared.fetchTodos()
        guard let date = notification.object as? Date else { return }
        self.currentDate = date
        self.filterTodoitems(date: self.currentDate!)
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    
    @objc func coreDataUpdated() {
        todoItems = CoreDataManager.shared.fetchTodos()
        self.filterTodoitems(date: self.currentDate ?? Date())
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    
    @objc func titleTouched() {
        if isPickerExpanded == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.periodBtnView.snp.updateConstraints{
                    $0.height.equalTo(0)
                }
                self.view.layoutIfNeeded()
            })
        }else{
            self.periodBtnView.currentState = self.currentState
            self.periodBtnView.configureButtons()
            UIView.animate(withDuration: 0.3, animations: {
                self.periodBtnView.snp.updateConstraints{
                    $0.height.equalTo(133)
                }
                self.view.layoutIfNeeded()
            })
        }
        isPickerExpanded.toggle()
    }
}

// Section 정의
extension TodoCalendarViewDifferableViewController {
    enum Section {
        case calendar
        case incomplete
        case complete
    }
    enum Item: Hashable {
        case calendarItem([Day])
        case incompleteItem(Todo)
        case completeItem(Todo)
    }
}

extension TodoCalendarViewDifferableViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            var height : CGFloat = 0
            switch self.currentState{
            case .month:
                height = maxCalendarHeight
            case .week:
                height = minCalendarHeight
            case .day:
                height = minCalendarHeight
            }
            return CGSize(width: collectionView.frame.width, height: height)
        default:
            return CGSize(width: collectionView.frame.width, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}


extension TodoCalendarViewDifferableViewController : PeriodPickerButtonViewDelegate {
    func didTapDailyButton(){}
    func didTapMonthButton(){
        currentState = .month
        NotificationCenter.default.post(name: NSNotification.Name("CalendarToggle"), object: currentState, userInfo: nil)
        UIView.animate(withDuration: 0.3) {
            self.periodBtnView.snp.updateConstraints{
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.updateDataSource()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }
        isPickerExpanded.toggle()
    }
    func didTapWeekButton(){
        currentState = .week
        NotificationCenter.default.post(name: NSNotification.Name("CalendarToggle"), object: currentState, userInfo: nil)
        UIView.animate(withDuration: 0.3) {
            self.periodBtnView.snp.updateConstraints{
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5) {
            self.updateDataSource()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }
        isPickerExpanded.toggle()
    }
}
