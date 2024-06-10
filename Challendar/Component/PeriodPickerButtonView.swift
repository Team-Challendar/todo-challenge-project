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
    
    private let buttonView1: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.text = "월간"
        label.textColor = .challendarBlack60
        label.font = .systemFont(ofSize: 17)
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .challendarBlack60
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(label.snp.trailing).offset(44) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    private let buttonView2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.text = "주간"
        label.textColor = .challendarBlack60
        label.font = .systemFont(ofSize: 17)
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .challendarBlack60
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(label.snp.trailing).offset(44) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    private let buttonView3: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.text = "일간"
        label.textColor = .challendarBlack60
        label.font = .systemFont(ofSize: 17)
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .challendarBlack60
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(label.snp.trailing).offset(44) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    private var buttonViews: [UIView] {
        return [buttonView1, buttonView2, buttonView3]
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
        addSubview(buttonView1)
        addSubview(buttonView2)
        addSubview(buttonView3)
        
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .black // 챌린지100으로 추후 수정
    }
    
    private func configureConstraint() {
        buttonView1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        buttonView2.snp.makeConstraints { make in
            make.top.equalTo(buttonView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        buttonView3.snp.makeConstraints { make in
            make.top.equalTo(buttonView2.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        addBorders()
    }
    
    private func addBorders() {
        for (index, buttonView) in buttonViews.enumerated() {
            if index > 0 {
                let border = UIView()
                border.backgroundColor = .challendarBlack60
                buttonView.addSubview(border)
                border.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.height.equalTo(0.5) // 경계선의 높이
                }
            }
        }
    }
    
    private func configureUtil() {
        setupActions()
    }
    
    private func setupActions() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonView1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonView2.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(dailyButtonTapped))
        buttonView3.addGestureRecognizer(tapGesture3)
    }
    
    @objc private func dailyButtonTapped() {
         delegate?.didTapdailyButton()
     }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        buttonViews.forEach {
            $0.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .challendarBlack60 }
            $0.subviews.compactMap { $0 as? UIImageView }.forEach { $0.tintColor = .challendarBlack60 }
        }
        if let tappedView = sender.view {
            tappedView.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .white }
            tappedView.subviews.compactMap { $0 as? UIImageView }.forEach { $0.tintColor = .white }
        }
    }
}
