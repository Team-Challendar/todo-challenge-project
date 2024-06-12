//
//  ChallengeSuccessViewController.swift
//  Challendar
//
//  Created by 서혜림 on 6/12/24.
//
import UIKit
//import Lottie

class ChallengeSuccessViewController: BaseViewController {
    var dimmedView = UIView()
    var isChallenge = true
    var imageView = UIImageView()
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarForSuccess()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.dismiss(animated: true)
        })
    }
    override func configureUI() {
        dimmedView.backgroundColor = UIColor.challendarBlack90.withAlphaComponent(dimmedViewAlpha)
        if isChallenge {
            imageView.image = .partyPopper
            textLabel.text = "오늘의 챌린지를 모두 완료했어요!"
        }
        textLabel.font = .pretendardSemiBold(size: 20)
        textLabel.textColor = .challendarWhite
        textLabel.backgroundColor = .clear
        imageView.backgroundColor = .clear
    }
    override func configureConstraint() {
        [dimmedView,imageView,textLabel].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        dimmedView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints{
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(296)
        }
        
        textLabel.snp.makeConstraints{
            $0.bottom.equalTo(imageView.snp.top).offset(32)
            $0.centerX.equalToSuperview()
        }
    }

}
