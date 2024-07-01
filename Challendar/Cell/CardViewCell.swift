//
//  CardViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 7/1/24.
//

import UIKit
import SnapKit

class CardViewCell: UIView {
    var imageView: UIImageView!
    var innerImageView: UIImageView!
    var titleLabel: UILabel!
    var todoStateView: UIView!
    var completeLabel: UILabel!
    var totalLabel: UILabel!
    private var slashLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        
        imageView = UIImageView()
        self.addSubview(imageView)
        
        innerImageView = UIImageView()
        imageView.addSubview(innerImageView)
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        todoStateView = UIView()
        todoStateView.backgroundColor = .clear
        self.addSubview(todoStateView)
        
        completeLabel = UILabel()
        completeLabel.font = .pretendardMedium(size: 18)
        completeLabel.textColor = .challendarWhite
        todoStateView.addSubview(completeLabel)
        
        slashLabel = UILabel()
        slashLabel.font = .pretendardMedium(size: 12)
        slashLabel.textColor = .secondary600
        slashLabel.text = "/"
        todoStateView.addSubview(slashLabel)
        
        totalLabel = UILabel()
        totalLabel.font = .pretendardMedium(size: 12)
        totalLabel.textColor = .secondary600
        todoStateView.addSubview(totalLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        innerImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        todoStateView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        completeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(slashLabel.snp.leading).offset(-4)
        }
        
        slashLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(totalLabel.snp.leading).offset(-4)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }
}
