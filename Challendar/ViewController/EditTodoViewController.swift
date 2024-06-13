import UIKit
import SnapKit

class EditTodoTitleViewController: BaseViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    // 계획 질문 UI 컴포넌트
    let titleLabel = EditTitleLabel(text: "어떤 계획이 생겼나요?")
    let titleView = EmptyView()
    
    let todoTextField: TodoTitleTextField = {
        let textField = TodoTitleTextField(placeholder: "")
        let placeholderText = "고양이 츄르 주문하기"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondary700
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    let dateAskLabel = EditTitleLabel(text: "기한을 정해주세요")
    let dateAskView = EmptyView()
    let dateView = DateView()
    
    var newTodo: Todo?
    var todoId: UUID?
    var dateRange: DateRange?
    var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(checkFirst: true)
        fetchTodo()
        todoTextField.delegate = self
        configureGestureRecognizers()
        setupNotificationCenter()
        
        // 제스처 인식기 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 제스처 인식기 메소드 추가
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 수정 버튼을 누르지 않고 화면이 사라질 때, 원래 상태로 돌아갑니다.
        fetchTodo()
    }
    
    
    override func configureConstraint() {
        titleView.addSubview(todoTextField)
        dateAskView.addSubview(dateView)
        
        [titleLabel, titleView, dateAskLabel, dateAskView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        todoTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(textFieldVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
        }
        
        dateAskLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        dateAskView.snp.makeConstraints {
            $0.height.equalTo(cellHeight)
            $0.top.equalTo(dateAskLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        
        dateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
        }
    }
    
    private func fetchTodo() {
        guard let todoId = todoId, let todoModel = CoreDataManager.shared.fetchTodoById(id: todoId) else {
            print("Todo not found")
            return
        }
        // 기존 투두의 title
        todoTextField.text = todoModel.title
        todoTextField.textColor = .secondary400
        todoTextField.font = .pretendardMedium(size: 18)
        
        // 값 임시 저장용 뉴 투두
        self.newTodo = Todo(id: todoModel.id, title: todoModel.title, memo: todoModel.memo, startDate: todoModel.startDate, endDate: todoModel.endDate, completed: todoModel.completed, isChallenge: todoModel.isChallenge, percentage: todoModel.percentage, iscompleted: todoModel.isCompleted)
        
        if let startDate = todoModel.startDate, let endDate = todoModel.endDate {
            self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
        }
    }
    
    private func updateDateViewTextForModel(startDate: Date, endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. d"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        if startDate.isSameDay(as: endDate) {
            if startDate.isSameDay(as: Date()) {
                self.dateView.textLabel.text = DateRange.today.rawValue
            } else if startDate.isSameDay(as: Date().addingDays(1)!) {
                self.dateView.textLabel.text = DateRange.tomorrow.rawValue
            } else {
                self.dateView.textLabel.text = "\(startDateString) - \(endDateString)"
            }
        } else if endDate.isSameDay(as: Date().addingDays(1)!) {
            self.dateView.textLabel.text = DateRange.tomorrow.rawValue
        } else if startDate <= Date() && endDate <= Date().addingDays(7)! {
            self.dateView.textLabel.text = DateRange.week.rawValue
        } else {
            self.dateView.textLabel.text = "\(startDateString) - \(endDateString)"
        }
    }
    
    private func configureGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        dateAskView.addGestureRecognizer(tapGesture)
        dateAskView.isUserInteractionEnabled = true
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("dateRange"), object: nil)
    }
    
    @objc func startDateChanged(notification: Notification) {
        guard let data = notification.object as? DateRange else { return }
        self.dateRange = data
        self.dateView.textLabel.text = data.rawValue
        editButton.setTitleColor(.challendarGreen200, for: .normal)
    }
    
    @objc private func dateViewTapped() {
        // dateView의 보더 추가
        dateAskView.layer.borderColor = UIColor.challendarGreen200.cgColor
        dateAskView.layer.borderWidth = 1.0
        dateView.textLabel.textColor = .challendarWhite
        
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.rootViewVC2 = self
        bottomSheetVC.newTodo = self.newTodo
        if let dateRange = dateRange {
            bottomSheetVC.dateRange = dateRange
        }
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = self
        
        bottomSheetVC.dismissCompletion = { [weak self] in
            guard let self = self else { return }
            self.dateAskView.layer.borderColor = UIColor.clear.cgColor
            self.dateAskView.layer.borderWidth = 0.0
            self.dateView.textLabel.textColor = .secondary400
            [self.titleLabel, self.titleView].forEach { view in
                view.alpha = 1.0
            }
            
            // 바텀시트가 닫힐 때 새로 저장된 뉴 투두로 값 표시
            if let startDate = self.newTodo?.startDate, let endDate = self.newTodo?.endDate {
                self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
            }
        }
        
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func dateRangeSelected(startDate: Date?, endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.newTodo?.startDate = startDate
        self.newTodo?.endDate = endDate
        
        // completed 배열을 초기화 >> 추후에 이야기 해봐야함
        self.newTodo?.completed = Array(repeating: false, count: Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1)
        
        self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
        
        self.dismiss(animated: true, completion: nil) // 바텀시트엥 디스미스 컴플리션
    }
    
    func configureNavigationForEdit(checkFirst: Bool) {
        let closeImageView = UIImageView()
        closeImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeImageView.image = .closeL
        closeImageView.addGestureRecognizer(tapGesture)
        closeImageView.backgroundColor = .clear
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let closeBarButtonItem = UIBarButtonItem(customView: closeImageView)
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        editButton = UIButton(type: .system)
        editButton.setTitle("수정", for: .normal)
        editButton.setTitleColor(.secondary700, for: .normal)
        editButton.titleLabel?.font = .pretendardBold(size: 16)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func editButtonTapped() {
        guard let todoId = todoId else { return }
        guard let title = todoTextField.text, !title.isEmpty else {
            return
        }
        
        // 수정 버튼이 눌렸을 대 코어 데이터에 업데이트
        CoreDataManager.shared.updateTodoById(id: todoId, newTitle: title, newStartDate: newTodo?.startDate, newEndDate: newTodo?.endDate, newCompleted: newTodo?.completed)
        print("수정 버튼이 눌렸습니다")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        editButton.setTitleColor(.challendarGreen200, for: .normal)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.challendarGreen200.cgColor
            titleView.layer.borderWidth = 1.0
            todoTextField.textColor = .challendarWhite
            [dateAskLabel, dateAskView].forEach { view in
                view.alpha = 0.3
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.clear.cgColor
            titleView.layer.borderWidth = 0.0
            todoTextField.textColor = .secondary400
            [dateAskLabel, dateAskView].forEach { view in
                view.alpha = 1.0
            }
        }
    }
}

class CustomPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.backgroundColor = .clear
    }
    
    override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.backgroundColor = .clear
    }
}
