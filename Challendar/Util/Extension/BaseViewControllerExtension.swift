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
            closeImageView.image = .arrowLeftNew
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
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeButtonTappedForSuccess(){
        NotificationCenter.default.post(name: NSNotification.Name("DismissSuccessView"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
