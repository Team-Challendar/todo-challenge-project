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
        setupTapGestures()
    }
    
    // 키보드와 텍스트 필드를 해제하는 탭 제스처 설정
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        outsideTapGesture.cancelsTouchesInView = false // dateAskView를 눌러도 텍스트 편집이 가능하게 설정
        view.addGestureRecognizer(outsideTapGesture)
    }
    
    // 화면 탭 시 키보드 없앰
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 특정 영역 외부 탭 시 타이핑 해제
    @objc private func dismissTextField(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !dateAskView.frame.contains(location) && !todoTextField.frame.contains(location) {
            view.endEditing(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 수정 버튼을 누르지 않으면 기존 투두 그대로
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
    
    // CoreData에서 Todo 항목을 불러온 뒤, 표시
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
        
        // endDate가 nil이 아닌 경우 iscompleted를 false로 설정
        if self.newTodo?.endDate != nil {
            self.newTodo?.iscompleted = false
        } else {
            // endDate가 nil인 경우 초기화
            self.newTodo?.completed = []
            self.newTodo?.iscompleted = false
        }
        
        if let startDate = todoModel.startDate, let endDate = todoModel.endDate {
            self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
        }
    }

    // 포매터로 dateView 텍스트 설정
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
    
    // 투두 날짜를 dateView 텍스트에 업데이트
    private func updateDateViewTextForModel(startDate: Date, endDate: Date, isHighlighted: Bool = false) {
        self.dateView.textLabel.attributedText = self.getAttributedDateText(startDate: startDate, endDate: endDate, isHighlighted: isHighlighted)
    }
    
    private func updateDateViewTextForLater() {
        self.dateView.textLabel.text = "나중에 정할래요"
    }
    
    // dateViewTapped를 호출하는 GestureRecognizer
    private func configureGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        dateAskView.addGestureRecognizer(tapGesture)
        dateAskView.isUserInteractionEnabled = true
    }
    
    // 날짜 범위 변경 노티피케이션
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("dateRange"), object: nil)
    }
    
    // 날짜 범위 변셕 시 dateView 텍스트 업데이트
    @objc func startDateChanged(notification: Notification) {
        guard let data = notification.object as? DateRange else { return }
        self.dateRange = data
        self.dateView.textLabel.text = data.rawValue
        editButton.setTitleColor(.challendarGreen200, for: .normal)
    }
    
    // dateView 탭 시 바텀 시트 표시, 선택한 날짜 범위로 dateView 택스트 업데이트
    @objc private func dateViewTapped() {
        view.endEditing(true)
        dateAskView.layer.borderColor = UIColor.challendarGreen200.cgColor
        dateAskView.layer.borderWidth = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            [self.titleLabel, self.titleView].forEach { view in
                view.alpha = 0.3
            }
        })
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.rootViewVC2 = self
        bottomSheetVC.newTodo = self.newTodo
        if let dateRange = dateRange {
            bottomSheetVC.dateRange = dateRange
        }
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = self
        
        bottomSheetVC.bottomSheetLaterButtonTapped = { [weak self] in
            guard let self = self else { return }
            guard let todoId = self.todoId, let todoModel = CoreDataManager.shared.fetchTodoById(id: todoId) else {
                return
            }
            todoModel.endDate = nil
            CoreDataManager.shared.updateTodoById(
                id: todoModel.id!,
                newTitle: todoModel.title,
                newStartDate: todoModel.startDate,
                newEndDate: nil,
                newCompleted: [],
                newIsChallenge: todoModel.isChallenge,
                newIsCompleted: false
            )
            
            self.newTodo?.endDate = nil
            self.newTodo?.isChallenge = false
            self.newTodo?.completed = []
            self.newTodo?.iscompleted = false
            self.updateDateViewTextForLater()
            print("BottomSheet Later Button Tapped - endDate set to nil, isChallenge set to false")
        }
        
        bottomSheetVC.dismissCompletion = { [weak self] in
            guard let self = self else { return }
            self.dateAskView.layer.borderColor = UIColor.clear.cgColor
            self.dateAskView.layer.borderWidth = 0.0
            if let startDate = self.newTodo?.startDate, let endDate = self.newTodo?.endDate, endDate != nil {
                self.updateDateViewTextForModel(startDate: startDate, endDate: endDate, isHighlighted: false)
            } else {
                self.updateDateViewTextForLater()
            }
            UIView.animate(withDuration: 0.2, animations: {
                [self.titleLabel, self.titleView].forEach { view in
                    view.alpha = 1.0
                }
            })
            
        }
        
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    //  바텀 시트를 표시
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // 선택된 새로운 날짜 범위로 newTodo 업데이트
    func dateRangeSelected(startDate: Date?, endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.newTodo?.startDate = startDate
        self.newTodo?.endDate = endDate
        
        // completed 배열을 초기화하지 않도록 수정
        self.updateDateViewTextForModel(startDate: startDate, endDate: endDate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // 네비게이션 바 UI
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
        editButton.setTitleColor(.challendarGreen200, for: .normal)
        editButton.titleLabel?.font = .pretendardBold(size: 16)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    // 수정 버튼을 탭했을 때 새로운 값 저장
    @objc func editButtonTapped() {
        guard let todoId = todoId else { return }
        guard let title = todoTextField.text, !title.isEmpty else {
            return
        }
        
        // 기존 투두 가져오기
        guard let todoModel = CoreDataManager.shared.fetchTodoById(id: todoId) else {
            return
        }
        
        // 기존 투두 날짜 범위
        let oldStartDate = todoModel.startDate
        let oldEndDate = todoModel.endDate
        
        // 새로운 투두 날짜 범위
        let newStartDate = newTodo?.startDate
        let newEndDate = newTodo?.endDate
        
        // 기존 completed 배열을 유지, 새로운 completed 배열 생성
        var updatedCompleted: [Bool] = []
        
        if let oldStart = oldStartDate, let newStart = newStartDate, let newEnd = newEndDate {
            let calendar = Calendar.current
            
            // 새로운 투두의 시작일부터 끝일까지 날짜 배열 생성
            var currentDate = newStart
            while currentDate <= newEnd {
                // 기존 completed 배열에서 해당 날짜의 값을 가져옴
                if let oldEnd = oldEndDate, currentDate >= oldStart && currentDate <= oldEnd {
                    let dayIndex = calendar.dateComponents([.day], from: oldStart, to: currentDate).day!
                    if dayIndex >= 0 && dayIndex < todoModel.completed.count {
                        updatedCompleted.append(todoModel.completed[dayIndex])
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
        
        // 새로운 endDate가 nil인 경우 completed 배열 초기화 및 iscompleted false로 설정
        if newEndDate == nil {
            newTodo?.completed = []
            newTodo?.iscompleted = false
        } else {
            newTodo?.completed = updatedCompleted
            newTodo?.iscompleted = false
        }
        
        // endDate가 nil인 경우 SuccessViewController 호출
        if newEndDate == nil {
            // 변경된 값을 코어 데이터에 업데이트
            CoreDataManager.shared.updateTodoById(
                id: todoId,
                newTitle: title,
                newStartDate: newStartDate,
                newEndDate: newEndDate,
                newCompleted: updatedCompleted,
                newIsChallenge: newTodo?.isChallenge ?? false,
                newIsCompleted: newEndDate == nil ? todoModel.isCompleted : false // endDate가 nil이 아닌 경우 false로 설정
            )
            
            // 기존 투두 업데이트
            newTodo?.title = title
            newTodo?.startDate = newStartDate
            newTodo?.endDate = newEndDate
            newTodo?.completed = updatedCompleted
            newTodo?.iscompleted = newEndDate == nil ? todoModel.isCompleted : false
            
            // 디버깅 로그 추가
            print("Updated Todo - Title: \(title), Completed: \(updatedCompleted), \(newEndDate)")
            
            // SuccessViewController 호출
            let successViewController = SuccessViewController()
            successViewController.isChallenge = false
            successViewController.endDate = newEndDate
            let navigationController = UINavigationController(rootViewController: successViewController)
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .overFullScreen

            self.dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootVC = window.rootViewController as? TabBarViewController {
                    rootVC.present(navigationController, animated: true, completion: nil)
                }
            }
        } else {
            // ChallengeCheckViewController 호출
            newTodo?.title = title
            newTodo?.startDate = newStartDate
            newTodo?.endDate = newEndDate
            newTodo?.completed = updatedCompleted
            newTodo?.iscompleted = newEndDate == nil ? todoModel.isCompleted : false
            
            // 디버깅 로그 추가
            print("Updated Todo - Title: \(title), Completed: \(updatedCompleted)")
            
            // ChallengeCheckViewController 호출
            newTodo?.isChallenge = false // 기본값 설정
            let challengeCheckVC = EditChallengeCheckViewController()
            challengeCheckVC.newTodo = newTodo
            challengeCheckVC.modalPresentationStyle = .overFullScreen
            
            // ChallengeCheckViewController에서 선택된 값에 따라 기존 투두 업데이트
            challengeCheckVC.laterButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.updateTodoIsChallenge(isChallenge: false, todoModel: todoModel, title: title, startDate: newStartDate, endDate: newEndDate, completed: updatedCompleted)
            }
            challengeCheckVC.challengeButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.updateTodoIsChallenge(isChallenge: true, todoModel: todoModel, title: title, startDate: newStartDate, endDate: newEndDate, completed: updatedCompleted)
            }
            
            self.present(challengeCheckVC, animated: true, completion: nil)
        }
    }

    // isChallenge 값이 변경된 투두 업데이트
    private func updateTodoIsChallenge(isChallenge: Bool, todoModel: TodoModel, title: String, startDate: Date?, endDate: Date?, completed: [Bool]) {
        todoModel.isChallenge = isChallenge
        todoModel.title = title
        todoModel.startDate = startDate
        todoModel.endDate = endDate
        todoModel.completed = completed
        CoreDataManager.shared.updateTodoById(
            id: todoModel.id!,
            newTitle: title,
            newStartDate: startDate,
            newEndDate: endDate,
            newCompleted: completed,
            newIsCompleted: endDate == nil ? todoModel.isCompleted : false
        )
        self.dismiss(animated: true, completion: nil)
    }

    // textField 수정 시 수정 버튼 컬러변경
    @objc func textFieldDidChange(_ textField: UITextField) {
           editButton.setTitleColor(.challendarGreen200, for: .normal)
       }
    
    // 타이핑 시작 시 UI 업데이트
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.challendarGreen200.cgColor
            titleView.layer.borderWidth = 1.0
            todoTextField.textColor = .challendarWhite
            UIView.animate(withDuration: 0.2, animations: {
                [self.dateAskLabel, self.dateAskView].forEach { view in
                    view.alpha = 0.3
                }
            })
            
        }
    }
    
    // 타이핑 종료 시 UI 업데이트
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.clear.cgColor
            titleView.layer.borderWidth = 0.0
            todoTextField.textColor = .secondary400
            UIView.animate(withDuration: 0.2, animations: {
                [self.dateAskLabel, self.dateAskView].forEach { view in
                    view.alpha = 1.0
                }
            })
        }
    }
}

// 바텀 시트 표시
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
