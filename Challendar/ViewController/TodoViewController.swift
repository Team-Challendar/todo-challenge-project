import UIKit
import SnapKit
import Lottie

class TodoViewController: BaseViewController {
    private var todoItems: [Todo] = []
    private var completedTodos: [Todo] = []
    private var incompleteTodos: [Todo] = []
    private var isPickerViewExpaned = false
    
    private var collectionView: UICollectionView!
    private let pickerBtnView = PickerBtnView()
    var dimmedView = UIView()
    var button = UIButton()
    
    
    
    override func viewDidLoad() {
        setupCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        configureNav(title: "최신순")

        loadData()
    }
    
    func configureNav(title: String){
        button = configureCalendarButtonNavigationBar(title: title)
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
    }
    
    // 리로드
    private func loadData() {
        self.todoItems = CoreDataManager.shared.fetchTodos()
        filterTodos()
        sortByRecentStartDate()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .secondary900
        dimmedView.backgroundColor = UIColor.secondary900.withAlphaComponent(0)
    }
    
    override func configureUtil() {
        super.configureUtil()
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(titleTouched))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        
        pickerBtnView.delegate = self
    }
    override func configureConstraint() {
        super.configureConstraint()
        view.addSubview(pickerBtnView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        dimmedView.addSubview(pickerBtnView)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let totalOffset = navigationBarHeight + statusBarHeight
            pickerBtnView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(totalOffset)
                $0.leading.equalToSuperview().offset(16)
                $0.height.equalTo(0)
                $0.width.equalTo(96)
            }
        }
        
    }
    
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
    
    func removeButtonView(){
        dimmedView.removeFromSuperview()
    }
    
    override func configureNotificationCenter() {
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataUpdated), name: NSNotification.Name("CoreDataChanged"), object: nil)
    }
    
    @objc func coreDataUpdated(_ notification: Notification) {
        loadData()
    }
    
    // 섹션 헤더 변경
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: "TodoCollectionViewCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .secondary900
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    // 컴포지셔널 레이아웃, createTodoSection 호출
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection(itemHeight: .absolute(75))
        }
    }
    // iscompleted 값으로 필터링
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
    
    private func sortByRecentStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
    }
    
    @objc func titleTouched() {
        guard let arrow = button.viewWithTag(1001) as? LottieAnimationView else { return }
        
        if isPickerViewExpaned {
            arrow.animationSpeed = 8
            arrow.play(fromProgress: 1.0, toProgress: 0.0, loopMode: .none)
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerBtnView.snp.updateConstraints{
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
            self.showButtonView()
            isPickerViewExpaned.toggle()
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerBtnView.snp.updateConstraints{
                    $0.height.equalTo(88.5)
                }
                self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(dimmedViewAlpha)
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SectionHeaderDelegate {
    // 완료 할 일, 미완료 할 일 값 유무에 따른 섹션 수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [completedTodos, incompleteTodos].filter { !$0.isEmpty }.count
    }
    
    // 이건 따로 메소드를 만들어 섹션 아이템 수를 계산했습니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTodoItem(for: section).count
    }
    
    // 셀에 값을 불러오는 부분입니다.
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
    
    // 섹션 헤더 델리게이트와 값을 불러오는 부분입니다.
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
    
    // 각 인덱스 값으로 해당하는 섹션 헤더 값을 반환합니다.
    private func getSectionHeaderTitle(for section: Int) -> String {
        let nonEmptySections = [incompleteTodos, completedTodos].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].offset == 0 ? "할 일" : "완료된 항목"
    }
    
    // 마찬가지로 인덱스 값에 해당하는 섹션의 todo 배열을 반환합니다. 이걸로 섹션 내의 todo 아이템들을 계산합니다.
    private func getTodoItem(for section: Int) -> [Todo] {
        let nonEmptySections = [incompleteTodos, completedTodos].enumerated().filter { !$0.element.isEmpty }
        return nonEmptySections[section].element
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    // 지우기 버튼 눌렀을 때, 각 섹션의 인덱스에 따라 완료, 미완료 항목에 해당하는 투두를 deleteTodoById로 삭제합니다.
    func didTapDeleteButton(in section: Int) {
        let nonEmptySections = [ incompleteTodos, completedTodos ].enumerated().filter { !$0.element.isEmpty }
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

extension TodoViewController : TodoViewCellDelegate {
    func editContainerTapped(in cell: TodoCollectionViewCell) {
        let editVC = EditTodoTitleViewController()
        editVC.todoId = cell.todoItem?.id
        editVC.modalTransitionStyle = .coverVertical
        editVC.modalPresentationStyle = .fullScreen
        self.present(editVC, animated: true, completion: nil)
    }
}

extension TodoViewController : PickerBtnViewDelegate {
    func didTapLatestOrderButton() {
        todoItems.reverse()
        completedTodos.reverse()
        incompleteTodos.reverse()
        collectionView.reloadData()
        titleTouched()
    }
    
    func didTapRegisteredOrderButton() {
        loadData() // 데이터를 다시 불러와서 원래 순서로 복원
        titleTouched()
    }
}
