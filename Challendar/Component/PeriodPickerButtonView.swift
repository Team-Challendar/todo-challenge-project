//
//  PeriodPickerButtonView.swift
//  Challendar
//
//  Created by 채나연 on 6/5/24.
//

import UIKit
import SnapKit

protocol PeriodPickerButtonViewDelegate {
    func didTapCalButton()
    func didTapDailyButton()
}
enum currentCalendar {
    case calendar
    case daily
}
class PeriodPickerButtonView: UIView {
    
    var delegate: PeriodPickerButtonViewDelegate?
    var currentState : currentCalendar? = .calendar
    private let buttonView1: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.text = "달력"
        label.textColor = .secondary700
        label.font = .pretendardRegular(size: 17)
        let imageView = UIImageView(image: .monthly0)
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
            make.size.equalTo(24) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    private let buttonView2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .secondary700
        label.font = .pretendardRegular(size: 17)
        let imageView = UIImageView(image: .daily0)
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
            make.size.equalTo(24) // 이미지와 텍스트 간의 간격을 넓힘
        }
        
        return view
    }()
    
    
    private var buttonViews: [UIView] {
        return [buttonView1, buttonView2]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
        configureUtil()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(buttonView1)
        addSubview(buttonView2)
        
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .secondary850 // 챌린지100으로 추후 수정
    }
    
    private func configureConstraint() {
        buttonView1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        buttonView2.snp.makeConstraints { make in
            make.top.equalTo(buttonView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
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
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(calButtonTapped))
        buttonView1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dailyButtonTapped))
        buttonView2.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func dailyButtonTapped() {
        self.currentState = .daily
        self.configureButtons()
        self.delegate?.didTapDailyButton()
     }
    
    @objc private func calButtonTapped() {
        self.currentState = .calendar
        self.configureButtons()
        self.delegate?.didTapCalButton()
     }
    
    func configureButtons() {
        switch currentState {
        case .calendar:
            buttonView2.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .secondary700 }
            buttonView2.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .daily0 }
            buttonView1.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .white }
            buttonView1.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .monthly1 }
        case .daily:
            buttonView1.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .secondary700 }
            buttonView1.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .monthly0 }
            buttonView2.subviews.compactMap { $0 as? UILabel }.forEach { $0.textColor = .white }
            buttonView2.subviews.compactMap { $0 as? UIImageView }.forEach { $0.image = .daily1 }
        default:
            return
        }
    }
}
