////
////  ViewController.swift
////  Challendar
////
////  Created by Sam.Lee on 5/30/24.
////
//
//import UIKit
//import SnapKit
//
//class TodoCalendarViewController: BaseViewController  {
//    var calendarView = TodoCalendarView()
//    private let periodBtnView = PeriodPickerButtonView() // 기간피커
//    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
//    private var completedTodo : [Todo] = []
//    private var inCompletedTodo: [Todo] = []
//    var days : [Day] = []
//    var changedMonth : Date?
//    var currentDate : Date?
//    private var collectionView: UICollectionView!
//    private var isFirstSectionExpanded = true
//    
//    override func viewDidLoad() {
//        filterTodoitems(date: currentDate ?? Date())
//        configureCollectionView()
//        configureCalendarView()
//        super.viewDidLoad()
//        configureFloatingButton()
//        configureNav()
//        periodBtnView.delegate = self
//        //        configureSwipping()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        filterTodoitems(date: currentDate ?? Date())
//    }
//    
//    func configureNav(){
//        let button = configureCalendarButtonNavigationBar(title: "월간")
//        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
//    }
//    override func configureNotificationCenter(){
//        super.configureNotificationCenter()
//        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name: NSNotification.Name("date"), object: currentDate)
//        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
//    }
//    private func filterTodoitems(date: Date = Date()){
//        self.todoItems = todoItems.filter({
//            $0.startDate != nil && $0.isChallenge == false
//        })
//        completedTodo = todoItems.filter({
//            $0.todayCompleted(date: date) == true
//        })
//        inCompletedTodo = todoItems.filter({
//            $0.todayCompleted(date: date) == false
//        })
//        days = Day.generateDaysForMonth(date: date, todos: self.todoItems)
//        calendarView.dayModelForCurrentPage = days
//        calendarView.calendar.reloadData()
//    }
//    override func configureUI() {
//        super.configureUI()
//        calendarView.snp.makeConstraints{
//            $0.height.equalTo(initialCalendarHeight)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
//            $0.leading.trailing.equalToSuperview().inset(16)
//        }
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(calendarView.snp.bottom).offset(16)
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
//            make.bottom.equalToSuperview()
//        }
//        //        view.addSubview(periodBtnView) // 기간피커
//        //
//        //        periodBtnView.snp.makeConstraints { make in
//        //            make.width.equalTo(131)
//        //            make.height.equalTo(133)
//        //            make.left.equalToSuperview().offset(16) // x 좌표 설정
//        //            make.top.equalToSuperview().offset(104) // y 좌표 설정
//        //        }
//    }
//    private func configureCalendarView(){
//        self.view.addSubview(calendarView)
//    }
//    
//    private func configureCollectionView() {
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .red
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.register(TodoCalendarViewCell.self, forCellWithReuseIdentifier: TodoCalendarViewCell.identifier)
//        collectionView.register(ChallengeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
//        collectionView.backgroundColor = .clear
//        view.addSubview(collectionView)
//    }
//    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            return createTodoSection()
//        }
//    }
//    
//    private func createTodoSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
//=======
//            switch sectionIndex {
//            case 0:
//                return self.createSpecialSection()
//            case 1, 2:
//                return self.createTodoSection(itemHeight: .estimated(75))
//            default:
//                return nil
//            }
//        }
//    }
////    
////    private func createTodoSection() -> NSCollectionLayoutSection {
////        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
////        let item = NSCollectionLayoutItem(layoutSize: itemSize)
////        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
////        
////        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
////        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
////        
////        let section = NSCollectionLayoutSection(group: group)
////        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
////        section.interGroupSpacing = 8
////        
////        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
////        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
////        //        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
////        section.boundarySupplementaryItems = [header]
////        
////        return section
////    }
////    
//    private func createSpecialSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
//>>>>>>> dev
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
//        section.interGroupSpacing = 8
//        
//<<<<<<< HEAD
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        //        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
//        section.boundarySupplementaryItems = [header]
//        
//        return section
//    }
//    
//=======
//        return section
//    }
//    @objc func dismissedFromSuccess(_ notification: Notification) {
//        todoItems = CoreDataManager.shared.fetchTodos()
//        filterTodoitems(date: currentDate ?? Date())
//        collectionView.reloadData()
//    }
//    @objc func monthChanged(notification : Notification){
//        guard let month = notification.object as? Date else {return}
//        self.currentDate = month.addingDays(1)!
//        self.filterTodoitems(date: month.addingDays(1)!)
//        collectionView.reloadData()
//    }
//>>>>>>> dev
//    @objc func dateChanged(notification : Notification){
//        guard let date = notification.object as? Date else {return}
//        self.currentDate = date
//        self.filterTodoitems(date: self.currentDate!)
//        collectionView.reloadData()
//    }
//    
//    @objc func coreDataUpdated(){
//        todoItems = CoreDataManager.shared.fetchTodos()
//        self.filterTodoitems(date:  self.currentDate ?? Date())
//        collectionView.reloadData()
//    }
//    @objc func titleTouched() {
//        isFirstSectionExpanded.toggle() // Toggle the state
//        
//        // Scroll to the top
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        
//        // Perform batch updates to ensure smooth layout change
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Slight delay to ensure scroll is completed
//            self.collectionView.performBatchUpdates({
//                // Invalidate the layout to ensure it gets recalculated
//                let context = UICollectionViewLayoutInvalidationContext()
//                context.invalidateItems(at: [IndexPath(item: 0, section: 0)])
//                self.collectionView.collectionViewLayout.invalidateLayout(with: context)
//            }, completion: { _ in
//                // Set the new layout without animation
//                self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
//                
//                // Animate the change smoothly
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.collectionView.layoutIfNeeded()
//                })
//            })
//        }
//        NotificationCenter.default.post(name: NSNotification.Name("CalendarToggle"), object: nil, userInfo: nil)
//    }
//    
//}
//extension TodoCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate  {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return inCompletedTodo.count
//        case 1:
//            return completedTodo.count
//        default:
//            return 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
//            cell.configure(with: inCompletedTodo[indexPath.item], date: self.currentDate ?? Date())
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarViewCell.identifier, for: indexPath) as! TodoCalendarViewCell
//            cell.configure(with: completedTodo[indexPath.item], date: self.currentDate ?? Date())
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ChallengeSectionHeader
//            switch indexPath.section {
//            case 0:
//                header.sectionLabel.text = "할일"
//            case 1:
//                header.sectionLabel.text = "완료된 투두"
//            default:
//                header.sectionLabel.text = "챌린지 투두"
//            }
//            return header
//        }
//        return UICollectionReusableView()
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        
//        if translation.y > 0 {
//            // 아래로 스크롤
//            self.calendarView.calendar.setScope(.month, animated: true)
//            UIView.animate(withDuration: 0.5) {
//                self.calendarView.snp.updateConstraints {
//                    $0.height.equalTo(maxCalendarHeight)
//                }
//                self.view.layoutIfNeeded()
//            }
//            
//        } else if translation.y < 0 {
//            // 위로 스크롤
//            UIView.animate(withDuration: 0.5) {
//                self.calendarView.snp.updateConstraints {
//                    $0.height.equalTo(minCalendarHeight)
//                }
//                self.view.layoutIfNeeded()
//            }
//            self.calendarView.calendar.setScope(.week, animated: true)
//        }
//    }
//}
//
//extension TodoCalendarViewController : PeriodPickerButtonViewDelegate {
//    func didTapdailyButton() {
//        let weeklyVC = DailyViewController() // 주간 뷰컨트롤러 인스턴스 생성
//        self.navigationController?.pushViewController(weeklyVC, animated: true)
//    }
//}
//
