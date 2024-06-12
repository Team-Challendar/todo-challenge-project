//
//  ChallengeSuccessViewController.swift
//  Challendar
//
//  Created by 서혜림 on 6/12/24.
//
import UIKit
import Lottie

class ChallengeSuccessViewController: BaseViewController {
    let animation = LottieAnimation.named("confettiAnimation")
    var animationView : LottieAnimationView!
    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var dimmedBackgroundView = UIView()
    var isChallenge = true
    var imageView = UIImageView()
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarForSuccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true)
            self.animationView.stop()
            //            self.animationView.removeFromSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .clear
        
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        dimmedBackgroundView.backgroundColor = UIColor(named: "challendarBlack")?.withAlphaComponent(0.5)
        dimmedBackgroundView.frame = view.bounds
        view.addSubview(dimmedBackgroundView)
        
        animationView = LottieAnimationView(animation: animation)
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill // 이 줄 추가
        view.addSubview(animationView)
        
        if isChallenge {
            imageView.image = .partyPopper
            textLabel.text = "오늘의 챌린지를 모두 완료했어요!"
        }
        
        textLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        textLabel.textColor = .white
        textLabel.backgroundColor = .clear
        imageView.backgroundColor = .clear
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        [imageView, textLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(296)
        }
        
        textLabel.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.top).offset(-32)
            $0.centerX.equalToSuperview()
        }
        animationView.snp.makeConstraints {
                   $0.edges.equalToSuperview() // 이 줄 수정
               }
//        animationView.snp.makeConstraints{
//            $0.height.equalToSuperview()
//            $0.center.equalToSuperview()
////            $0.edges.equalTo(view)
////            $0.height.equalTo(view)
//        }
        
        //        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        //           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
        //            window.addSubview(animationView)
        //            animationView.translatesAutoresizingMaskIntoConstraints = false
        //            animationView.snp.makeConstraints {
        //                $0.edges.equalTo(window)
        //            }
        //        }
    }
}
