import UIKit
import SnapKit

extension BaseViewController{
    
    func configureFloatingButton(){
        let floatingButton = FloatingButton()
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.snp.makeConstraints{
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.width.equalTo(60)
        }
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func floatingButtonTapped(){
        let editTodoVC = AddTodoTitleViewController()
        let navigationController = UINavigationController(rootViewController: editTodoVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
        
    }
    
    func configureTitleNavigationBar(title: String){
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardSemiBold(size: 26)
        titleLabel.textColor = .challendarWhite100
        titleLabel.backgroundColor = .clear
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
        configureSettingButtonNavigationBar()
    }
    
    func configureCalendarButtonNavigationBar(title: String) -> UIButton {
        let arrow = UIImageView()
        arrow.image = .arrowDown
        arrow.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardSemiBold(size: 26)
        titleLabel.textColor = .challendarWhite100
        titleLabel.backgroundColor = .clear
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        
        [arrow, titleLabel].forEach {
            button.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
        }
        titleLabel.sizeToFit()
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(45 + 4 + 24 + 5)
        }
        
        let titleBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
        
        configureSettingButtonNavigationBar()
        
        return button
    }
    func configureBackAndTitleNavigationBar(title: String) {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardSemiBold(size: 26)
        titleLabel.textColor = .challendarWhite100
        titleLabel.backgroundColor = .clear
        
        let closeImageView = UIImageView()
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.image = .arrowLeftL
        closeImageView.backgroundColor = .clear
        
        [closeImageView,titleLabel].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(305)// 예시로 높이를 설정합니다. 필요에 따라 조정하세요.
        }
        
        closeImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(closeImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        
        closeImageView.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        let titleBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
    }
    func configureNavigationBar(checkFirst: Bool){
        let closeImageView = UIImageView()
        closeImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        if checkFirst {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
            closeImageView.image = .closeL
        }else{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
            closeImageView.image = .arrowLeftL
        }
        closeImageView.addGestureRecognizer(tapGesture)
        closeImageView.backgroundColor = .clear
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        let closeBarButtonItem = UIBarButtonItem(customView: closeImageView)
        
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func configureNavigationBarForSuccess(){
        let closeImageView = UIImageView()
        closeImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTappedForSuccess))
        closeImageView.image = .closeL
        closeImageView.addGestureRecognizer(tapGesture)
        closeImageView.backgroundColor = .clear
        closeImageView.translatesAutoresizingMaskIntoConstraints = false
        let closeBarButtonItem = UIBarButtonItem(customView: closeImageView)
        
        self.navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func configureSettingButtonNavigationBar(){
        let settingImageView = UIImageView()
        settingImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        settingImageView.contentMode = .scaleAspectFill
        settingImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(settingButtonTapped))
        settingImageView.image = .settingIcon
        settingImageView.addGestureRecognizer(tapGesture)
        settingImageView.backgroundColor = .clear
        settingImageView.translatesAutoresizingMaskIntoConstraints = false
        let settingBarButton = UIBarButtonItem(customView: settingImageView)
        
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func settingButtonTapped(){
        let nextVC = SettingViewController()
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }
    @objc func closeButtonTappedForSuccess(){
        NotificationCenter.default.post(name: NSNotification.Name("DismissSuccessView"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
