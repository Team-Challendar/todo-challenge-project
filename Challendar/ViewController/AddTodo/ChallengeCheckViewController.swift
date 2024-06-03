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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(checkFirst: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLayout()
        newTodo?.description()
    }
    override func configureUI() {
        super.configureUI()
        dimmedView.backgroundColor = UIColor.challendarBlack90
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
//    override func configureUtil() {
//        <#code#>
//    }
    
    private func showLayout(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear,  animations: {
            self.dimmedView.alpha = dimmedViewAlpha
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

}
