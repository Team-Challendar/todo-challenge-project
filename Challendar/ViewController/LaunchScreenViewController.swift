//
//  LunchScreenViewController.swift
//  Challendar
//
//  Created by 채나연 on 6/13/24.
//

import UIKit
import Lottie
import SnapKit

// LaunchScreenViewController 클래스는 앱의 런치 스크린을 관리
class LaunchScreenViewController: UIViewController {

    private var animationView: LottieAnimationView? // Lottie 애니메이션 뷰
    private var titleLabel: UILabel! // 타이틀 라벨
    private var subLabel: UILabel! // 서브 라벨

    // 뷰가 로드되었을 때 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondary900 // 배경 색상 설정
        setupTitleLabel() // 타이틀 라벨 설정
        setupAnimation() // 애니메이션 설정
    }

    // 뷰가 나타났을 때 호출되는 메서드
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let tabBarViewController = TabBarViewController()
            tabBarViewController.modalPresentationStyle = .overFullScreen
            tabBarViewController.modalTransitionStyle = .crossDissolve

            // 새로운 rootViewController를 TabBarViewController로 설정
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarViewController

                // 전환 애니메이션 추가
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                window.layer.add(transition, forKey: kCATransition)
            }
        }
    }

    // 타이틀 라벨을 설정하는 함수
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121)
            $0.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        subLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // 애니메이션을 설정하는 함수
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

            animationView.play() // 애니메이션 재생
        }
    }
}
