//
//  ChallengePopUpView.swift
//  Challendar
//
//  Created by Sam.Lee on 6/4/24.
//

import UIKit
import SnapKit

class ChallengePopUpView: UIView {
    var stackView = UIStackView()
    var laterButton = CustomButton()
    var challengeButton = CustomButton()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraint()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureConstraint()
    }
    

    func configureUI(){
        self.backgroundColor = .challendarBlack80
        self.layer.cornerRadius = 20
        self.layer.cornerCurve = .continuous
        
        laterButton.laterMediumState()
        challengeButton.challengeState()
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        imageView.image = .temp
        
        titleLabel.text = "도전 목록에 추가 하시겠어요?"
        titleLabel.font = .pretendardSemiBold(size: 20)
        titleLabel.textColor = .challendarWhite
        titleLabel.textAlignment = .center
        
        subTitleLabel.text = Speech.list.randomElement()?.text
        subTitleLabel.font = .pretendardRegular(size: 13)
        subTitleLabel.textColor = .challendarGrey50
        subTitleLabel.textAlignment = .center
        
    }
    
    func configureConstraint() {
        [stackView,imageView, titleLabel, subTitleLabel].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [laterButton,challengeButton].forEach{
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
            $0.top.equalToSuperview().offset(32)
        }
        
        titleLabel.snp.makeConstraints{
            $0.height.equalTo(38)
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints{
            $0.height.equalTo(13)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            $0.height.equalTo(44)
        }
        
    }
}
