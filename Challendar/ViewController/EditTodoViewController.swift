import UIKit
import SnapKit

class EditTodoViewController: BaseViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    // 계획 질문 UI 컴포넌트
    let titleLabel = EditTitleLabel(text: "어떤 계획이 생겼나요?")
    let titleView = EmptyView()
    
    let todoTextField: TodoTitleTextField = {
        let textField = TodoTitleTextField(placeholder: "")
        let placeholderText = "할 일을 입력해주세요"
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
        
        configureNavigationForEdit(checkFirst: true)
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
        
        // completed 확인용 디버깅 로그
        print("Fetched Todo - Title: \(todoModel.title), Completed: \(todoModel.completed)")
        
        if let startDate = todoModel.startDate, let endDate = todoModel.endDate {
            self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
        }
    }
    
    private func getAttributedDateText(startDate: Date?, endDate: Date?, isHighlighted: Bool) -> NSAttributedString {
        guard let startDate = startDate, let endDate = endDate else { return NSAttributedString(string: "") }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let fullString = "\(startDateString) - \(endDateString)"
        let attributedString = NSMutableAttributedString(string: fullString)
        
        let defaultColor: UIColor = isHighlighted ? .challendarWhite : .secondary400
        attributedString.addAttribute(.foregroundColor, value: defaultColor, range: NSRange(location: 0, length: attributedString.length))
        
        if let range = fullString.range(of: "-") {
            let nsRange = NSRange(range, in: fullString)
            let highlightColor = isHighlighted ? UIColor.challendarGreen200 : UIColor.secondary400
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
        }
        
        return attributedString
    }
    
    private func updateDateViewTextForModel(startDate: Date, endDate: Date, isHighlighted: Bool = false) {
        self.dateView.textLabel.attributedText = self.getAttributedDateText(startDate: startDate, endDate: endDate, isHighlighted: isHighlighted)
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
        titleView.layer.borderWidth = 0.0
        dateView.textLabel.attributedText = getAttributedDateText(startDate: newTodo?.startDate, endDate: newTodo?.endDate, isHighlighted: true)
        [self.titleLabel, self.titleView].forEach { view in
            view.alpha = 0.3
        }
        
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
            self.dateView.textLabel.attributedText = self.getAttributedDateText(startDate: self.newTodo?.startDate, endDate: self.newTodo?.endDate, isHighlighted: false)
            [self.titleLabel, self.titleView].forEach { view in
                view.alpha = 1.0
            }
            
            // 바텀시트가 닫힐 때 새로 저장된 뉴 투두로 값 표시
            if let startDate = self.newTodo?.startDate, let endDate = self.newTodo?.endDate {
                self.updateDateViewTextForModel(startDate: startDate, endDate: endDate, isHighlighted: false)
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
        
        // completed 배열을 초기화하지 않도록 수정
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
        
        // 기존 투두 가져오기
        guard let existingTodo = CoreDataManager.shared.fetchTodoById(id: todoId) else {
            return
        }
        
        // 기존 투두의 날짜 범위
        let oldStartDate = existingTodo.startDate
        let oldEndDate = existingTodo.endDate
        
        // 새로운 투두의 날짜 범위
        let newStartDate = newTodo?.startDate
        let newEndDate = newTodo?.endDate
        
        // 기존 completed 배열을 유지하면서 새로운 completed 배열 생성
        var updatedCompleted: [Bool] = []
        
        if let oldStart = oldStartDate, let oldEnd = oldEndDate, let newStart = newStartDate, let newEnd = newEndDate {
            let calendar = Calendar.current
            
            // 새로운 투두의 시작일부터 끝일까지 날짜 배열 생성
            var currentDate = newStart
            while currentDate <= newEnd {
                // 기존 completed 배열에서 해당 날짜의 값을 가져옴
                if currentDate >= oldStart && currentDate <= oldEnd {
                    let dayIndex = calendar.dateComponents([.day], from: oldStart, to: currentDate).day!
                    if dayIndex < existingTodo.completed.count {
                        updatedCompleted.append(existingTodo.completed[dayIndex])
                    } else {
                        updatedCompleted.append(false)
                    }
                } else {
                    // 새로운 날짜는 기본값 false로 설정
                    updatedCompleted.append(false)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }
        
        // 변경된 값을 코어 데이터에 업데이트
        CoreDataManager.shared.updateTodoById(
            id: todoId,
            newTitle: title,
            newStartDate: newTodo?.startDate,
            newEndDate: newTodo?.endDate,
            newCompleted: updatedCompleted
        )
        
        // 디버깅 로그 추가
        print("Updated Todo - Title: \(title), Completed: \(updatedCompleted)")
        
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
