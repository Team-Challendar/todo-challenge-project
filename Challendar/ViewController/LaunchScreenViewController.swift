//
//  LunchScreenViewController.swift
//  Challendar
//
//  Created by 채나연 on 6/13/24.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    private var animationView: LottieAnimationView?
    private var titleLabel: UILabel!
    private var subLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondary900
        setupTitleLabel()
        setupAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            let tabBarViewController = TabBarViewController()
            tabBarViewController.modalPresentationStyle = .overFullScreen
            tabBarViewController.modalTransitionStyle = .crossDissolve
            self.show(tabBarViewController, sender: self)
        })
    }
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "챌린더"
        titleLabel.textColor = .challendarWhite
        titleLabel.font = UIFont.pretendardSemiBold(size: 38)
        titleLabel.textAlignment = .center
        
        subLabel = UILabel()
        subLabel.text = "쉽게 쓰고 관리하는 나의 도전"
        subLabel.textColor = .secondary700
        subLabel.font = UIFont.pretendardSemiBold(size: 18)
        subLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        view.addSubview(subLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 121), // 기존 122에서 1만큼 위로 올림
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 147),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -147)
        ])
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15), // 기존 20에서 5만큼 위로 올림
            subLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 94),
            subLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -94)
        ])
    }

    private func setupAnimation() {
        animationView = LottieAnimationView(name: "Logo")
        if let animationView = animationView {
            animationView.loopMode = .playOnce
            animationView.contentMode = .scaleAspectFit
            view.addSubview(animationView)

            animationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -43), // 기존 -58에서 15만큼 아래로 내림
                animationView.widthAnchor.constraint(equalToConstant: 185),
                animationView.heightAnchor.constraint(equalToConstant: 185)
            ])

            animationView.play()
        }
    }
}
