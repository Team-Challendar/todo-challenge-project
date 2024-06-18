import UIKit
import Lottie

class TodoCalendarViewDifferableViewController: BaseViewController{
    var calendarView = TodoCalendarView()
    var dimmedView = UIView()
    var dailyView = DailyView()
    var topContainer = UIView()
    private let periodBtnView = PeriodPickerButtonView() // 기간피커
    private var button : UIButton!
    private var collectionView: UICollectionView!
    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodo : [Todo] = []
    private var inCompletedTodo: [Todo] = []
    var days : [Day]?
    var currentState: currentCalendar? = .calendar
    var currentDate : Date?
    private var isPickerViewExpaned = false
    var day: Day?
    var nextMonth : Date?
    var prevMonth : Date?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    // 뷰가 로드될 때 호출
    override func viewDidLoad() {
        configureCollectionView()
        super.viewDidLoad()
        filterTodoitems(date: currentDate ?? Date())
        configureNav(title: "달력")
        configureDataSource()
        configureFloatingButton()
    }
    // UI 구성
    override func configureUI() {
        super.configureUI()
        dimmedView.backgroundColor = UIColor.secondary900.withAlphaComponent(0)
        topContainer.backgroundColor = .clear
        dailyView.isHidden = true
    }
    // 유틸리티 구성
    override func configureUtil() {
        super.configureUtil()
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(titleTouched))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        periodBtnView.delegate = self
        
    }
    // NotificationCenter 구성
    override func configureNotificationCenter(){
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name: NSNotification.Name("date"), object: currentDate)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
    }
    // 제약 조건 구성
    override func configureConstraint() {
        super.configureConstraint()
        
        [collectionView!,topContainer].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [calendarView,dailyView].forEach{
            topContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        topContainer.snp.makeConstraints{
            $0.height.equalTo(initialCalendarHeight)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        dailyView.snp.makeConstraints{
            $0.height.equalTo(300)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        calendarView.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
        }
        dimmedView.addSubview(periodBtnView)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let totalOffset = navigationBarHeight + statusBarHeight
            periodBtnView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(totalOffset)
                $0.leading.equalToSuperview().offset(16)
                $0.height.equalTo(0)
                $0.width.equalTo(131)
            }
        }
        
    }
    // 버튼 뷰 표시 (달력 / 일간 변경 뷰)
    func showButtonView(){
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(dimmedView)
            dimmedView.translatesAutoresizingMaskIntoConstraints = false
            dimmedView.snp.makeConstraints {
                $0.edges.equalTo(window)
            }
        }
    }
    // 버튼 뷰 제거
    func removeButtonView(){
        dimmedView.removeFromSuperview()
    }
    // 네비게이션 바 구성
    func configureNav(title: String){
        button = configureCalendarButtonNavigationBar(title: title)
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
    }
    // 컬렉션 뷰 구성
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DailyGaugeCollectionViewCell.self, forCellWithReuseIdentifier: DailyGaugeCollectionViewCell.identifier)
        collectionView.register(TodoCalendarViewCell.self, forCellWithReuseIdentifier: TodoCalendarViewCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 83, right: 0)
                collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    // 컴포지셔널 레이아웃 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if self.currentState == .daily{
                if sectionIndex == 0 {
                    return self.createSpecialSection(itemHeight: .estimated(152))
                }else{
                    return self.createTodoSection(itemHeight: .estimated(75))
                }
            }else{
                return self.createTodoSection(itemHeight: .estimated(75))
            }
            
            
        }
    }
    // Todo 항목 필터링
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
        day = days?.first(where: {$0.date.isSameDay(as: date) })
        calendarView.dayModelForCurrentPage = days
        calendarView.selectedDate = date
        calendarView.calendar.select(date)
//        calendarView.calendar.reloadData()
        dailyView.configure(with: days!,selectedDate: date)
        let targetIndex = date.indexForDate()
        self.dailyView.layout.scrollToPage(atIndex: targetIndex, animated: false)
    }
    
    // 데이터 소스 설정
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: collectionView) { (collectionView, indexPath, sectionItem) -> UICollectionViewCell? in
            switch sectionItem{
            case .progressItem(let day):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyGaugeCollectionViewCell.identifier, for: indexPath) as? DailyGaugeCollectionViewCell else {return nil}
                cell.configure(day: day)
                return cell
            case .incompleteItem(let incompletedTodo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
                cell.configure(with: incompletedTodo, date: self.currentDate ?? Date())
                cell.delegate = self
                return cell
            case .completeItem(let completedTodo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
                cell.configure(with: completedTodo, date: self.currentDate ?? Date())
                cell.delegate = self
                return cell
            }
            
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            if self.currentState == .calendar {
                switch indexPath.section {
                case 0:
                    header.sectionLabel.text = "할 일"
                case 1:
                    header.sectionLabel.text = "완료"
                default:
                    header.sectionLabel.text = "챌린지 투두"
                }
            }else{
                switch indexPath.section {
                case 0:
                    header.sectionLabel.text = "오늘의 계획 실행률"
                case 1:
                    header.sectionLabel.text = "할 일"
                case 2:
                    header.sectionLabel.text = "완료"
                default:
                    header.sectionLabel.text = "챌린지 투두"
                }
            }
            
            return header
        }
        updateDataSource()
    }
    
    // 데이터 업데이트
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        if currentState == .daily {
            snapshot.appendSections([.progress, .incomplete, .complete])
            if let day = day {
                snapshot.appendItems([.progressItem(day)], toSection: .progress)
            }
        }else{
            snapshot.appendSections([.incomplete, .complete])
        }

        snapshot.appendItems(inCompletedTodo.map{.incompleteItem($0)}, toSection: .incomplete)
        snapshot.appendItems(completedTodo.map{.completeItem($0)}, toSection: .complete)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    // 날짜 변경 알림 처리
    @objc func dateChanged(notification : Notification){
        guard let date = notification.object as? Date else {return}
        self.currentDate = date
        completedTodo = []
        inCompletedTodo = []
        updateDataSource()
        self.filterTodoitems(date: date)
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    // Core Data 업데이트 알림 처리
    @objc func coreDataUpdated(){
        todoItems = CoreDataManager.shared.fetchTodos()
        self.filterTodoitems(date:  self.currentDate ?? Date())
        updateDataSource() // 데이터 업데이트 메서드 호출
    }
    // 제목 터치 처리
    @objc func titleTouched() {
        guard let arrow = button.viewWithTag(1001) as? LottieAnimationView else { return }
        
        if isPickerViewExpaned {
            arrow.animationSpeed = 8
            arrow.play(fromProgress: 1.0, toProgress: 0.0, loopMode: .none)
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.periodBtnView.snp.updateConstraints{
                    $0.height.equalTo(0)
                }
                self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0)
                self.view.layoutIfNeeded()
            },completion: {_ in
                self.removeButtonView()
            })
            
        }else{
            arrow.animationSpeed = 8
            arrow.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .none)
            showButtonView()
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.periodBtnView.snp.updateConstraints{
                    $0.height.equalTo(88.5)
                }
                self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(dimmedViewAlpha)
                self.view.layoutIfNeeded()
            })
        }
    }
}

// Section 정의
extension TodoCalendarViewDifferableViewController {
    enum Section {
        case progress
        case incomplete
        case complete
    }
    
    enum SectionItem : Hashable{
        case progressItem(Day)
        case incompleteItem(Todo)
        case completeItem(Todo)
    }
}


extension TodoCalendarViewDifferableViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentState == .calendar{
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            
            if translation.y > 0 {
                // 아래로 스크롤
                self.calendarView.calendar.setScope(.month, animated: true)
                UIView.animate(withDuration: 0.5) {
                    self.topContainer.snp.updateConstraints {
                        $0.height.equalTo(maxCalendarHeight)
                    }
                    self.view.layoutIfNeeded()
                }
                self.calendarView.calendar.reloadData()
                
            } else if translation.y < 0 {
                // 위로 스크롤
                UIView.animate(withDuration: 0.5, animations: {
                    self.topContainer.snp.updateConstraints {
                        $0.height.equalTo(minCalendarHeight)
                    }
                    self.calendarView.calendar.setScope(.week, animated: true)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
//                    self.calendarView.calendar.reloadData()
                })
                
                
            }
        }
    }
    
}

extension TodoCalendarViewDifferableViewController : TodoCalendarCollectionViewCellDelegate {
    func editContainerTapped(in cell: TodoCalendarViewCell) {
        let editVC = EditTodoViewController()
        editVC.todoId = cell.todoItem?.id
        editVC.modalTransitionStyle = .coverVertical
        editVC.modalPresentationStyle = .overFullScreen
        let navi = UINavigationController(rootViewController: editVC)
        navi.modalPresentationStyle = .overFullScreen
        self.present(navi, animated: true, completion: nil)
    }
}
// (달력/날짜) pickerButtonView 터치 처리
extension TodoCalendarViewDifferableViewController : PeriodPickerButtonViewDelegate {
    func didTapDailyButton(){
        currentState = .daily
        configureNav(title: "날짜")
        titleTouched()
        self.calendarView.isHidden = true
        self.dailyView.isHidden = false
        if let currentDate = self.currentDate {
            let targetIndex = currentDate.indexForDate()
            self.dailyView.layout.scrollToPage(atIndex: targetIndex, animated: false)
        }else{
            let targetIndex = Date().indexForDate()
            self.dailyView.layout.scrollToPage(atIndex: targetIndex, animated: false)
        }
       
        UIView.animate(withDuration: 0.5) {
            self.topContainer.snp.updateConstraints {
                $0.height.equalTo(300)
            }
            self.view.layoutIfNeeded()
        }
        updateDataSource()
    }
    func didTapCalButton(){
        currentState = .calendar
        configureNav(title: "달력")
        titleTouched()
        self.calendarView.selectedDate = self.currentDate
        self.calendarView.isHidden = false
        self.dailyView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.topContainer.snp.updateConstraints {
                $0.height.equalTo(maxCalendarHeight)
            }
            self.view.layoutIfNeeded()
        }
        self.calendarView.calendar.setScope(.month, animated: false)
        self.calendarView.calendar.select(self.currentDate)
//        self.calendarView.calendar.reloadData()
        updateDataSource()
    }
}
