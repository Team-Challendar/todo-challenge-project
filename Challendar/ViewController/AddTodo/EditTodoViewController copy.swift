import UIKit
import SnapKit



class EditTodoTitleViewController: BaseViewController {
    
    
    // 계획 질문 UI 컴포넌트
    let titleLabel = EditTitleLabel(text: "어떤 계획이 생겼나요?")
    let titleView = EmptyView()
    
    let todoTextField = TodoTitleTextField(placeholder: "고양이 츄르 주문하기")
    
    // 기한 질문 UI 컴포넌트
    let dateAskLabel = EditTitleLabel(text: "기한을 선택해주세요")
    let dateAskView = EmptyView()
    let dateview = DateView()
    var newTodo : Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(checkFirst: true)
        
        titleLabel.backgroundColor = .systemPink
        titleView.backgroundColor = .cyan
        todoTextField.backgroundColor = .black
        
        dateAskLabel.backgroundColor = .blue
        dateAskView.backgroundColor = .green
    }
    
    
    override func configureConstraint(){
        
        
        titleView.addSubview(todoTextField)
        
        [titleLabel, titleView, dateAskLabel, dateAskView, dateView].forEach{
            self.view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        todoTextField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(textFieldVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
        }
        
        dateAskLabel.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            
        }
        dateAskView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.top.equalTo(dateAskLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        
//        dateView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
//            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
//        }
//            $0.top.equalTo(dateAskLabel.snp.bottom).offset(24)
//            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
//            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
            
        }


//func configureNavigationBar(checkFirst: Bool){
//        let closeImageView = UIImageView()
//        closeImageView.snp.makeConstraints{
//            $0.width.height.equalTo(24)
//        }
//        closeImageView.contentMode = .scaleAspectFill
//        closeImageView.isUserInteractionEnabled = true
//        var tapGesture = UITapGestureRecognizer()
//        if checkFirst {
//            tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped)) // 닫기 -> 수정버튼으로 변경
//            closeImageView.image = .closeL
//        }else{
//            tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))  // 뒤로가기 유지
//            closeImageView.image = .arrowLeftL
//        }
//        closeImageView.addGestureRecognizer(tapGesture)
//        closeImageView.backgroundColor = .clear
//        closeImageView.translatesAutoresizingMaskIntoConstraints = false
//        let closeBarButtonItem = UIBarButtonItem(customView: closeImageView)
//        
//        self.navigationItem.leftBarButtonItem = closeBarButtonItem
//    }
    

