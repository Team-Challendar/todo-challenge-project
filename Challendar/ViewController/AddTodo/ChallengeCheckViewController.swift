//
//  ChallengeCheckViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChallengeCheckViewController: BaseViewController {
    var dimmedView = UIView()
    var newTodo: Todo?
    var challengePopUp = ChallengePopUpView()
    var dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(checkFirst: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLayout()
    }
    override func configureUtil() {
        super.configureUtil()
        challengePopUp.laterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.newTodo?.isChallenge = false
                self?.showSuccessVC()
            }).disposed(by: self.dispose)
        
        challengePopUp.challengeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.newTodo?.isChallenge = true
                self?.showSuccessVC()
            }).disposed(by: self.dispose)
    }
    override func configureUI() {
        super.configureUI()
        dimmedView.backgroundColor = UIColor.secondary900
        dimmedView.alpha = 0
    }
    override func configureConstraint() {
        super.configureConstraint()
        [dimmedView,challengePopUp].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        dimmedView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        challengePopUp.snp.makeConstraints{
            $0.height.equalTo(popUpHeight)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.centerY.equalToSuperview()
            
        }
    }
    
    private func showLayout(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear,  animations: {
            self.dimmedView.alpha = 100
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func showSuccessVC(){
        CoreDataManager.shared.createTodo(newTodo: (self.newTodo)!)
        let rootView = self.presentingViewController
        let successViewController = SuccessViewController()
        successViewController.isChallenge = self.newTodo!.isChallenge
        let navigationController = UINavigationController(rootViewController: successViewController)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overFullScreen
        self.dismiss(animated: false, completion: {
            rootView?.present(navigationController, animated: true)
        })
    }
}
