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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            NotificationCenter.default.post(name: NSNotification.Name("DismissSuccessView"), object: nil, userInfo: nil)
            self.dismiss(animated: true)
        })
    }
    override func configureUI() {
        dimmedView.backgroundColor = UIColor.challendarBlack90.withAlphaComponent(dimmedViewAlpha)
        if isChallenge {
            imageView.image = .partyPopper
            textLabel.text = "도전 목록에 추가했어요!"
        }else{
            imageView.image = .thumbUp
            textLabel.text = "할 일을 등록했어요!"
        }
        textLabel.font = .pretendardSemiBold(size: 20)
        textLabel.textColor = .challendarWhite100
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
            $0.top.equalToSuperview().offset(297)
        }
        
        textLabel.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }

}
