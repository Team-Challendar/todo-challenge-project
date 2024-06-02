import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddTodoStartViewController: BaseViewController {
    
    let titleLabel = EditTitleLabel(text: "언제 시작할까요")
    let titleView = EmptyView()
    let dateView = DateView()
    let confirmButton = ConfirmButton()
    var dispose = DisposeBag()
    var newTodo : Todo?
    var startDate : StartDate? {
        didSet{
            if startDate != .manual {
                confirmButton.changeTitle(title: "다음")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        configureNavigationBar(checkFirst: false)
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("startDate"), object: startDate)
    }
    override func configureUI(){
        confirmButton.changeTitle(title: "할일 등록")
        confirmButton.highLightState()
    }
    
    override func configureConstraint(){
        [titleLabel, titleView,confirmButton].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleView.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        dateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
        }
        confirmButton.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-12)
            $0.height.equalTo(buttonHeight)
        }
    }
    override func configureUtil(){
        confirmButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(AddTodoEndViewController(), animated: true)
            })
            .disposed(by: self.dispose)
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        titleView.addGestureRecognizer(gesture)
        
        gesture.rx.event
            .bind(
                onNext: { [weak self] recongnizer in
            self?.titleViewDidTapped()
                }).disposed(by: self.dispose)
        
    }
    
    private func titleViewDidTapped(){
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.dateBottomSheet.startDate = StartDate.none
        self.present(bottomSheetVC, animated: false,completion: nil)
    }
    @objc func startDateChanged(notification : Notification) {
        guard let data = notification.object as? StartDate else {return}
        self.startDate = data
        self.dateView.textLabel.text = data.rawValue
    }
}


