//
//  SuccessViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/3/24.
//

import UIKit

class SuccessViewController: BaseViewController {
    var dimmedView = UIView()
    var isChallenge = false
    var endDate: Date?
    var imageView = UIImageView()
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarForSuccess()
        navigateToAppropriateTab()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func configureUI() {
        dimmedView.backgroundColor = UIColor.secondary900.withAlphaComponent(dimmedViewAlpha)
        
        if endDate == nil {
            imageView.image = .thumbUp
            textLabel.text = "할 일을 추가했어요!"
        } else if isChallenge {
            imageView.image = .partyPopper
            textLabel.text = "도전 목록에 추가했어요!"
        } else {
            imageView.image = .calendarIcon
            textLabel.text = "계획 목록에 추가했어요!"
        }
        
        textLabel.font = .pretendardSemiBold(size: 20)
        textLabel.textColor = .challendarWhite
        textLabel.backgroundColor = .clear
        imageView.backgroundColor = .clear
    }

    override func configureConstraint() {
        [dimmedView, imageView, textLabel].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(297)
        }
        textLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }

    private func navigateToAppropriateTab() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let tabBarController = window.rootViewController as? UITabBarController else {
            return
        }

        if endDate == nil {
            tabBarController.selectedViewController = tabBarController.viewControllers?[1]
        } else if isChallenge {
            tabBarController.selectedViewController = tabBarController.viewControllers?[0]
        } else {
            tabBarController.selectedViewController = tabBarController.viewControllers?[2]
        }
    }
}
