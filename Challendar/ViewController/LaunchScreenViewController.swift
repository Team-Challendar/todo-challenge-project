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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }

    private func setupAnimation() {
        // 로티 애니메이션 설정
        animationView = LottieAnimationView(name: "Logo")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.0
        
        view.addSubview(animationView!)
        
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView!.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        animationView?.play()
    }
}



