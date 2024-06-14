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
    
    // EditTodoVC에서 사용될 콜백 추가했습니다.
    var laterButtonTapped: (() -> Void)?
    var challengeButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
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
                self?.laterButtonTapped?()
                self?.showSuccessVC()
            }).disposed(by: self.dispose)
        
        challengePopUp.challengeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.newTodo?.isChallenge = true
                self?.challengeButtonTapped?()
                self?.showSuccessVC()
            }).disposed(by: self.dispose)
    }
    override func configureUI() {
        super.configureUI()
        dimmedView.backgroundColor = UIColor.challendarBlack
        dimmedView.alpha = 0
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
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
            self.dimmedView.alpha = dimmedViewAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func showSuccessVC(){
        CoreDataManager.shared.createTodo(newTodo: (self.newTodo)!)
        
        let rootView = self.presentingViewController
        let rootViewRoot = rootView?.presentingViewController
        let successViewController = SuccessViewController()
        successViewController.isChallenge = self.newTodo!.isChallenge
        let navigationController = UINavigationController(rootViewController: successViewController)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overFullScreen
        self.dismiss(animated: false, completion: {
            rootView?.dismiss(animated: false, completion: {
                rootViewRoot?.present(navigationController, animated: true)
            })
        })
    }
}
