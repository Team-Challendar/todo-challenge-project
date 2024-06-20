import UIKit
import SnapKit
import Lottie

extension BaseViewController{
    
    func configureFloatingButton() -> FloatingButton{
        let floatingButton = FloatingButton()
        self.view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.snp.makeConstraints{
            $0.width.equalTo(128)
            $0.height.equalTo(52)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        return floatingButton
    }
    
//    @objc private func floatingButtonTapped(){
//        let editTodoVC = AddTodoTitleViewController()
//        let navigationController = UINavigationController(rootViewController: editTodoVC)
//        navigationController.modalTransitionStyle = .coverVertical
//        navigationController.modalPresentationStyle = .overFullScreen
//        self.present(navigationController, animated: true)
//    }
    
    @objc private func floatingButtonTapped() {
        let editTodoVC = AddTodoBottomSheetViewController()
        editTodoVC.modalTransitionStyle = .crossDissolve
        editTodoVC.modalPresentationStyle = .overFullScreen
        self.present(editTodoVC, animated: true)
    }
    
    func configureTitleNavigationBar(title: String){
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardMedium(size: 20)
        titleLabel.textColor = .challendarWhite
        titleLabel.backgroundColor = .clear
        
        let flagImageView = UIImageView()
        flagImageView.contentMode = .scaleAspectFill
        flagImageView.image = .challengeFlag
        flagImageView.backgroundColor = .clear
        
        [flagImageView,titleLabel].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(305)// 예시로 높이를 설정합니다. 필요에 따라 조정하세요.
        }
        
        flagImageView.snp.makeConstraints{
            $0.width.height.equalTo(28)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(flagImageView.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let titleBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
        self.configureSettingButtonNavigationBar()
    }
    
    func configureCalendarButtonNavigationBar(title: String) -> UIButton {
        let animation = LottieAnimation.named("dropDown")
        let animationView = LottieAnimationView(animation: animation)
        animationView.tag = 1001
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardSemiBold(size: 18)
        titleLabel.textColor = .challendarWhite
        titleLabel.backgroundColor = .clear
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        
        [animationView, titleLabel].forEach {
            button.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
        }
        titleLabel.sizeToFit()
        animationView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(70)
        }
        
        let titleBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
        
        configureSettingButtonNavigationBar()
        
        return button
    }
    func configureBackAndTitleNavigationBar(title: String, checkSetting: Bool) {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        
        titleLabel.textColor = .challendarWhite
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
        if checkSetting {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
            titleLabel.font = .pretendardSemiBold(size: 20)
        }else{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
            titleLabel.font = .pretendardMedium(size: 20)
        }
        
        
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
        settingImageView.image = .settingIcon.withTintColor(.white, renderingMode: .alwaysOriginal)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func createTodoSection(itemHeight: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(itemHeight.dimension))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(8))
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createSpecialSection(itemHeight: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(itemHeight.dimension))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 8
        
        return section
    }
}

