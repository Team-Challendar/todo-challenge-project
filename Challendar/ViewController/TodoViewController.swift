import UIKit
import SnapKit
import Lottie

// TodoViewController는 BaseViewController를 상속받아 할 일 목록을 관리
class TodoViewController: BaseViewController {
    private var todoItems: [Todo] = [] // 모든 할 일 항목
    private var completedTodos: [Todo] = [] // 완료된 할 일 항목
    private var incompleteTodos: [Todo] = [] // 미완료된 할 일 항목
    private var isPickerViewExpaned = false // 피커 뷰 확장 여부
    
    private var collectionView: UICollectionView!
    private let pickerBtnView = PickerBtnView()
    var dimmedView = UIView()
    var button = UIButton()
    
    // 뷰가 로드되었을 때 호출되는 메서드
    override func viewDidLoad() {
        setupCollectionView() // 컬렉션 뷰 설정
        super.viewDidLoad()
        configureFloatingButton() // 플로팅 버튼 설정
        configureNav(title: "최신순") // 네비게이션 바 설정
        loadData() // 데이터 로드
    }
    
    // 네비게이션 바를 설정하는 함수
    func configureNav(title: String) {
        button = configureCalendarButtonNavigationBar(title: title)
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
    }
    
    // 데이터를 로드하고 필터 및 정렬을 수행
    private func loadData() {
        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // UI를 설정하는 함수
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .secondary900
        dimmedView.backgroundColor = UIColor.secondary900.withAlphaComponent(0)
    }
    
    // 유틸리티 설정 함수
    override func configureUtil() {
        super.configureUtil()
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(titleTouched))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        pickerBtnView.delegate = self
    }
    
    // 제약 조건을 설정하는 함수
    override func configureConstraint() {
        super.configureConstraint()
        view.addSubview(pickerBtnView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        dimmedView.addSubview(pickerBtnView)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let totalOffset = navigationBarHeight + statusBarHeight
            pickerBtnView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(totalOffset)
                $0.leading.equalToSuperview().offset(16)
                $0.height.equalTo(0)
                $0.width.equalTo(96)
            }
        }
    }
    
    // 버튼 뷰를 보여주는 함수
    func showButtonView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(dimmedView)
            dimmedView.translatesAutoresizingMaskIntoConstraints = false
            dimmedView.snp.makeConstraints {
                $0.edges.equalTo(window)
            }
        }
    }
    
    // 버튼 뷰를 제거하는 함수
    func removeButtonView() {
        dimmedView.removeFromSuperview()
    }
    
    // 노티피케이션 센터를 설정하는 함수
    override func configureNotificationCenter() {
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
    }
    
    // Core Data가 업데이트되었을 때 호출되는 함수
    @objc func coreDataUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    // 섹션 헤더를 설정하는 함수
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "TodoCollectionViewCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .secondary900
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 83, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    // 컴포지셔널 레이아웃을 생성하는 함수
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .absolute(75))
        }
    }
    
    // todoItems를 완료 및 미완료 항목으로 필터링
    private func filterTodos() {
        let filteredItems = todoItems.filter {
            $0.endDate == nil
        }
        completedTodos = filteredItems.filter {
            $0.iscompleted
        }
        incompleteTodos = filteredItems.filter {
            !$0.iscompleted
        }
    }
    
    // 완료 및 미완료 항목을 최근 시작 날짜 기준으로 정렬
    private func sortByRecentStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
    }
    
    // 제목이 터치되었을 때 호출되는 함수
    @objc func titleTouched() {
        guard let arrow = button.viewWithTag(1001) as? LottieAnimationView else { return }
        
        if isPickerViewExpaned {
            arrow.animationSpeed = 8
            arrow.play(fromProgress: 1.0, toProgress: 0.0, loopMode: .none)
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerBtnView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
                self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.removeButtonView()
            })
        } else {
            arrow.animationSpeed = 8
            arrow.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .none)
            self.showButtonView()
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerBtnView.snp.updateConstraints {
                    $0.height.equalTo(88.5)
                }
                self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(dimmedViewAlpha)
                self.view.layoutIfNeeded()
            })
        }
    }
}

// UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SectionHeaderDelegate 프로토콜을 채택
extension TodoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SectionHeaderDelegate {
    
    // 완료 할 일, 미완료 할 일 값 유무에 따른 섹션 수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [completedTodos, incompleteTodos].filter { !$0.isEmpty }.count
    }
    
    // 섹션 내 아이템 수를 반환하는 함수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItem(for: section).count
    }
    
    // 셀을 구성하는 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCollectionViewCell", for: indexPath) as? TodoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let todo = getTodoItem(for: indexPath.section)[indexPath.item]
        cell.configure(with: todo)
        cell.checkButton.isSelected = todo.iscompleted // 체크박스 상태 설정
        cell.delegate = self
        return cell
    }
    
    // 섹션 헤더를 구성하는 함수
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        header.sectionLabel.text = getSectionHeaderTitle(for: indexPath.section)
        header.section = indexPath.section
        header.delegate = self
        header.showDeleteButton()
        if header.sectionLabel.text == "할 일" {
            header.hideDeleteButton()
        }
        return header
    }
    
    // 각 인덱스 값으로 해당하는 섹션 헤더 값을 반환하는 함수
    private func getSectionHeaderTitle(for section: Int) -> String {
        let nonEmptySections = [incompleteTodos, completedTodos].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].offset == 0 ? "할 일" : "완료된 항목"
    }
    
    // 인덱스 값에 해당하는 섹션의 todo 배열을 반환하는 함수
    private func getTodoItem(for section: Int) -> [Todo] {
        let nonEmptySections = [incompleteTodos, completedTodos].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].element
    }
    
    // 아이템 크기를 설정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
    
    // 섹션 간격을 설정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // 섹션 헤더 크기를 설정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    // 지우기 버튼이 눌렸을 때 호출되는 함수
    func didTapDeleteButton(in section: Int) {
        let nonEmptySections = [incompleteTodos, completedTodos].enumerated().filter { !$0.element.isEmpty }
        let sectionIndex = nonEmptySections[section].offset
        
        let todosToDelete: [Todo]
        if sectionIndex == 0 {
            todosToDelete = incompleteTodos
        } else {
            todosToDelete = completedTodos
        }
        
        for todo in todosToDelete {
            CoreDataManager.shared.deleteTodoById(id: todo.id!)
        }
        
        loadData()
    }
}

// TodoViewCellDelegate 프로토콜을 채택
extension TodoViewController: TodoViewCellDelegate {
    // 편집 컨테이너가 탭되었을 때 호출되는 함수
    func editContainerTapped(in cell: TodoCollectionViewCell) {
        let editVC = EditTodoViewController()
        editVC.todoId = cell.todoItem?.id
        editVC.modalTransitionStyle = .coverVertical
        editVC.modalPresentationStyle = .fullScreen
        let navi = UINavigationController(rootViewController: editVC)
        navi.modalPresentationStyle = .overFullScreen
        self.present(navi, animated: true, completion: nil)
    }
}

// PickerBtnViewDelegate 프로토콜을 채택
extension TodoViewController: PickerBtnViewDelegate {
    // 최신순 버튼이 눌렸을 때 호출되는 함수
    func didTapLatestOrderButton() {
        configureNav(title: "최신순")
        todoItems.reverse()
        completedTodos.reverse()
        incompleteTodos.reverse()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        titleTouched()
    }
    
    // 등록순 버튼이 눌렸을 때 호출되는 함수
    func didTapRegisteredOrderButton() {
        configureNav(title: "등록순")
        loadData() // 데이터를 다시 불러와서 원래 순서로 복원
        titleTouched()
    }
}

