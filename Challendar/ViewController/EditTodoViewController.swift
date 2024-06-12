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
        return textField
    }()
    
    
    // 기한 질문 UI 컴포넌트
    let dateAskLabel = EditTitleLabel(text: "기한을 정해주세요")
    let dateAskView = EmptyView()
    let dateView = DateView()
    
    var newTodo: Todo?
    var todoId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(checkFirst: true)
        fetchTodo()
        view.backgroundColor = .secondary900
        configureNavigationForEdit(checkFirst: true)
        titleView.backgroundColor = .secondary850
        dateAskView.backgroundColor = .secondary850
        todoTextField.delegate = self
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
            } else if startDate.isSameDay(as: Date().addingDays(-1)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.tomorrow.rawValue
            } else if startDate.isSameDay(as: Date().addingDays(-7)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.week.rawValue
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. M. d"
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                dateView.textLabel.text = "\(startDateString) - \(endDateString)"
            }
        }
    }
    
    func configureNavigationForEdit(checkFirst: Bool) {
 
        
        // UIImageView 생성 및 크기 설정
        let closeImageView = UIImageView()
        closeImageView.snp.makeConstraints {
            $0.width.height.equalTo(24) // 이미지 뷰의 너비와 높이를 24로 설정
        }
        closeImageView.contentMode = .scaleAspectFill // 이미지 뷰의 콘텐츠 모드를 설정하여 이미지가 뷰의 경계를 넘지 않도록 설정
        closeImageView.isUserInteractionEnabled = true // 사용자 인터랙션을 허용하도록 설정 (터치 이벤트 감지 가능)
        
        // UITapGestureRecognizer 초기화
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeImageView.image = .closeL // 닫기 버튼 이미지 설정 (가정: .closeL은 닫기 이미지를 나타냄)
        closeImageView.addGestureRecognizer(tapGesture)
        closeImageView.backgroundColor = .clear // 배경색을 투명하게 설정
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // UIImageView를 포함하는 UIBarButtonItem 생성
        let closeBarButtonItem = UIBarButtonItem(customView: closeImageView)
        
        // 네비게이션 바의 버튼 아이템으로 설정
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
        
        // "수정" 버튼 생성 및 설정
        let editButton = UIButton(type: .system)
        editButton.setTitle("수정", for: .normal)
        editButton.setTitleColor(.secondary700, for: .normal)
        editButton.titleLabel?.font = .pretendardBold(size: 16)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        // "수정" 버튼을 포함하는 UIBarButtonItem 생성
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        
        // 네비게이션 바의 오른쪽 버튼 아이템으로 설정
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func editButtonTapped() {
        // 수정 버튼의 액션 처리
        print("수정 버튼이 눌렸습니다")
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
