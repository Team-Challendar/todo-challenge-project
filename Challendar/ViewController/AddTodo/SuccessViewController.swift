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
    var imageView = UIImageView()
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarForSuccess()
        navigateToAppropriateTab()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }

    override func configureUI() {
        dimmedView.backgroundColor = UIColor.secondary900.withAlphaComponent(dimmedViewAlpha)
        if isChallenge {
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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? TabBarViewController {
            if isChallenge {
                tabBarController.selectedIndex = 0
            } else {
                tabBarController.selectedIndex = 2
            }
        }
    }
}
