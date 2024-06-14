//
//  LunchScreenViewController.swift
//  Challendar
//
//  Created by 채나연 on 6/13/24.
//

import UIKit
import Lottie
import SnapKit
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

//    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
//            self.dismiss(animated: false)
//            let tabBarViewController = TabBarViewController()
//            tabBarViewController.modalPresentationStyle = .overFullScreen
//            tabBarViewController.modalTransitionStyle = .crossDissolve
//            self.show(tabBarViewController, sender: self)
//            
//        })
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let tabBarViewController = TabBarViewController()
            tabBarViewController.modalPresentationStyle = .overFullScreen
            tabBarViewController.modalTransitionStyle = .crossDissolve

            // Set the new rootViewController to TabBarViewController
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarViewController

                // Add transition animation
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                window.layer.add(transition, forKey: kCATransition)
            }
        }
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
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121)
            $0.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        subLabel.translatesAutoresizingMaskIntoConstraints = false
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
