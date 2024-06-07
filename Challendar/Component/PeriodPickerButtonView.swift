//
//  PeriodPickerButtonView.swift
//  Challendar
//
//  Created by 채나연 on 6/5/24.
//

import UIKit
import SnapKit


protocol PeriodPickerButtonViewDelegate: AnyObject {
    func didTapdailyButton()
}

class PeriodPickerButtonView: UIView {
    
    weak var delegate: PeriodPickerButtonViewDelegate?
    
    private let button1: UIButton = {
         let button = UIButton()
         var configuration = UIButton.Configuration.plain()
         configuration.title = "월간"
         configuration.image = UIImage(systemName: "calendar")
         configuration.imagePadding = 44 // 이미지와 텍스트 간의 간격을 넓힘
         configuration.imagePlacement = .trailing
         configuration.baseBackgroundColor = .clear // 배경 색상을 투명으로 설정
         button.configuration = configuration
         button.setTitleColor(.challendarBlack60, for: .normal)
         button.setTitleColor(.white, for: .selected)
         button.tintColor = .challendarBlack60
         button.contentHorizontalAlignment = .center
         return button
     }()
    
    private let button2: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "주간"
        configuration.image = UIImage(systemName: "calendar")
        configuration.imagePadding = 44
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .clear // 배경 색상을 투명으로 설정
        button.configuration = configuration
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.tintColor = .challendarBlack60
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private let button3: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "일간"
        configuration.image = UIImage(systemName: "calendar")
        configuration.imagePadding = 44
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .clear // 배경 색상을 투명으로 설정
        button.configuration = configuration
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.tintColor = .challendarBlack60
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .challendarBlack60
        return view
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .challendarBlack60
        return view
    }()
    
    private var buttons: [UIButton] {
        return [button1, button2, button3]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
        configureUtil()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(button1)
        addSubview(button2)
        addSubview(button3)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .black // 챌린지100으로 추후 수정
    }
    
    private func configureConstraint() {
        button1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        topSeparator.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.2) // 얇은 실선의 높이
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.2) // 얇은 실선의 높이
        }
    }
    
    private func configureUtil() {
        setupActions()
    }
    
    private func setupActions() {
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(dailyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func dailyButtonTapped() {
         delegate?.didTapdailyButton()
     }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons.forEach {
            $0.isSelected = false
            $0.tintColor = .challendarBlack60 // 기본 색상으로 되돌림
        }
        sender.isSelected = true
        sender.tintColor = .white // 선택된 버튼 색상 변경
    }
}

