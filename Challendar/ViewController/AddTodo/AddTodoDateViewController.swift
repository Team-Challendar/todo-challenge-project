import UIKit
import SnapKit
import RxSwift
import RxCocoa
// 날짜 선택화면
class AddTodoDateViewController: BaseViewController {
    let titleLabel = EditTitleLabel(text: "기한을 선택해주세요") // 타이틀 레이블
    let titleView = EmptyView() // 타이틀 뷰
    let dateView = DateView() // 날짜 뷰
    let confirmButton = CustomButton() // 확인 버튼
    var dispose = DisposeBag() // RxSwift 디스포즈 백
    var newTodo: Todo? // 새 할 일
    var dateRange: DateRange? // 날짜 범위
    
    // 뷰가 로드될 때 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter() // 알림 센터 설정
        configureNavigationBar(checkFirst: false) // 네비게이션 바 설정
    }
    
    // 알림 센터 설정
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("dateRange"), object: dateRange)
        NotificationCenter.default.addObserver(self, selector: #selector(dateChangedFromCal), name: NSNotification.Name("todo"), object: newTodo)
    }
    
    // UI 구성
    override func configureUI() {
        confirmButton.changeTitle(title: "할 일 등록")
        confirmButton.highLightState()
    }
    
    // 제약 조건 구성
    override func configureConstraint() {
        [titleLabel, titleView, confirmButton].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleView.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        dateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
        }
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-12)
            $0.height.equalTo(buttonHeight)
        }
    }
    
    // 유틸리티 구성
    override func configureUtil() {
        // 확인 버튼 탭 처리
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.confirmButtonTapped()
            })
            .disposed(by: self.dispose)
        
        // 제스처 설정
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        titleView.addGestureRecognizer(gesture)
        
        gesture.rx.event
            .bind(onNext: { [weak self] recognizer in
                self?.titleViewDidTapped()
            }).disposed(by: self.dispose)
    }
    
    // 타이틀 뷰 탭 처리
    private func titleViewDidTapped() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.rootViewVC = self
        bottomSheetVC.newTodo = self.newTodo
        if let dateRange = dateRange {
            bottomSheetVC.dateRange = dateRange
        }
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    // 시작 날짜 변경 알림 처리
    @objc func startDateChanged(notification: Notification) {
        guard let data = notification.object as? DateRange else { return }
        self.dateRange = data
        self.newTodo?.startDate = Date().startOfDay()
        self.newTodo?.endDate = data.date
        self.dateView.textLabel.text = data.rawValue
    }
    
    // 달력에서 날짜 변경 알림 처리
    @objc func dateChangedFromCal(notification: Notification) {
        guard let new = notification.object as? Todo else { return }
        self.dateRange = .manual
        self.newTodo?.startDate = new.startDate
        self.newTodo?.endDate = new.endDate
        self.dateView.textLabel.text = new.startDate!.startToEndDate(date: new.endDate!)
    }
    
    // 확인 버튼 탭 처리
    private func confirmButtonTapped() {
        if self.dateRange == nil {
            self.newTodo?.startDate = Date()
            CoreDataManager.shared.createTodo(newTodo: self.newTodo!)
            let rootView = self.presentingViewController
            let successViewController = SuccessViewController()
            successViewController.isChallenge = false
            let navigationController = UINavigationController(rootViewController: successViewController)
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .overFullScreen
            self.dismiss(animated: false, completion: {
                rootView?.present(navigationController, animated: true)
            })
        } else if self.dateRange == .manual {
            let challengeCheckViewController = ChallengeCheckViewController()
            challengeCheckViewController.newTodo = self.newTodo
            self.present(challengeCheckViewController, animated: true)
        } else {
            self.newTodo?.startDate = Date().startOfDay()
            self.newTodo?.endDate = self.dateRange?.date
            let challengeCheckViewController = ChallengeCheckViewController()
            challengeCheckViewController.newTodo = self.newTodo
            self.present(challengeCheckViewController, animated: true)
        }
    }
}
