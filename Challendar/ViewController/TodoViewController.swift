import UIKit
import SnapKit



class TodoViewController: BaseViewController, PickerBtnViewDelegate {
    
    private let pickerBtnView = PickerBtnView()
    private var todoItems: [Todo] = []
    private var completedTodos: [Todo] = []         // 완료 투두
    private var incompleteTodos: [Todo] = []        // 미완료 투두
    private var collectionView: UICollectionView!
    var button = UIButton()
    override func viewDidLoad() {
        setupCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        button = configureCalendarButtonNavigationBar(title: "최신순")
        button.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
        pickerBtnView.delegate = self
        loadData()
   
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    pickerBtnView.delegate = self
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
//        pickerBtnView.isHidden = true // 처음에는 숨김 상태로 설정 // 델리게이트 설정
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        view.addSubview(pickerBtnView)
        pickerBtnView.snp.makeConstraints { make in
            make.width.equalTo(96)
            //  make.height.equalTo(0) // 초기 높이를 0으로 설정
            make.height.equalTo(88.5)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(98)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
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
    
    
    // PickerBtnViewDelegate 메소드 구현
    func didTapDailyButton() {
        // Implement this function if needed
    }
    
    func didTapLatestOrderButton() {
        todoItems.reverse()
        completedTodos.reverse()
        incompleteTodos.reverse()
        collectionView.reloadData()
    }
    
    func didTapRegisteredOrderButton() {
        loadData() // 데이터를 다시 불러와서 원래 순서로 복원
    }
    
//    func didSelectOption(_ option: String) {
//        // 드롭다운 옵션 선택 시 처리
//        print("Selected option: \(option)")
//        pickerBtnView.isHidden.toggle()
//    }
    
    @objc func titleTouched(){
//        pickerBtnView.isHidden.toggle()
//        
        if self.pickerBtnView.frame.height > 0 {
            UIView.animate(withDuration: 0.3) {
                self.pickerBtnView.snp.updateConstraints { make in
                    make.height.equalTo(88.5)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func dismissPicker() {
         if self.pickerBtnView.frame.height > 0 {
             UIView.animate(withDuration: 0.3) {
                 self.pickerBtnView.snp.updateConstraints { make in
                     make.height.equalTo(0)
                 }
                 self.view.layoutIfNeeded()
             }
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
