import UIKit
import SnapKit

class EditTodoTitleViewController: BaseViewController, UITextFieldDelegate {
    
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
    
    // 기한 질문 UI 컴포넌트
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
        view.backgroundColor = .secondary900
        configureNavigationForEdit(checkFirst: true)
        titleView.backgroundColor = .secondary850
        dateAskView.backgroundColor = .secondary850
        todoTextField.delegate = self
        
        configureGestureRecognizers()
        setupNotificationCenter()
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
        
        // 투두의 제목을 텍스트 필드에 설정
        todoTextField.text = todoModel.title
        
        // 투두의 날짜 범위를 dateView에 설정
        if let startDate = todoModel.startDate, let endDate = todoModel.endDate {
            if startDate.isSameDay(as: endDate) {
                dateView.textLabel.text = DateRange.today.rawValue
                self.dateRange = .today
            } else if startDate.isSameDay(as: Date().addingDays(-1)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.tomorrow.rawValue
                self.dateRange = .tomorrow
            } else if startDate.isSameDay(as: Date().addingDays(-7)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.week.rawValue
                self.dateRange = .week
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. M. d"
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                dateView.textLabel.text = "\(startDateString) - \(endDateString)"
                self.dateRange = .manual
            }
        }
        
        self.newTodo = Todo(id: todoModel.id, title: todoModel.title, memo: todoModel.memo, startDate: todoModel.startDate, endDate: todoModel.endDate, completed: todoModel.completed, isChallenge: todoModel.isChallenge, percentage: todoModel.percentage, iscompleted: todoModel.isCompleted)
    }
    
    private func configureGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateViewTapped))
        dateView.addGestureRecognizer(tapGesture)
        dateView.isUserInteractionEnabled = true
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("dateRange"), object: nil)
    }
    
    @objc func startDateChanged(notification: Notification) {
        guard let data = notification.object as? DateRange else { return }
        self.dateRange = data
        self.dateView.textLabel.text = data.rawValue
        editButton.setTitleColor(.red, for: .normal)
    }
    
    @objc private func dateViewTapped(){
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.rootViewVC2 = self
        bottomSheetVC.newTodo = self.newTodo
        if let dateRange = dateRange {
            bottomSheetVC.dateRange = dateRange
        }
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false,completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        editButton.setTitleColor(.red, for: .normal)
    }
    
    // BottomSheetViewControllerDelegate 메소드 구현
    func dateRangeSelected(startDate: Date?, endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.newTodo?.startDate = startDate
        self.newTodo?.endDate = endDate

        // completed 배열을 초기화
        self.newTodo?.completed = Array(repeating: false, count: Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. d"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        dateView.textLabel.text = "\(startDateString) - \(endDateString)"
        editButton.setTitleColor(.red, for: .normal)
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
            // Handle empty title case
            return
        }
        // 변경사항을 코어 데이터에 반영
        CoreDataManager.shared.updateTodoById(id: todoId, newTitle: title, newStartDate: newTodo?.startDate, newEndDate: newTodo?.endDate, newCompleted: newTodo?.completed)
        print("수정 버튼이 눌렸습니다")
        self.dismiss(animated: true, completion: nil)
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.challendarGreen200.cgColor
            titleView.layer.borderWidth = 1.0
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == todoTextField {
            titleView.layer.borderColor = UIColor.clear.cgColor
            titleView.layer.borderWidth = 0.0
        }
    }
}
