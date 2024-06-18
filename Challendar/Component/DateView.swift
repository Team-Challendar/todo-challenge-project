//
//  DateView.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
// Add / Edit 페이지에서 날짜 선택 UIView
class DateView: UIView {

    var textLabel = UILabel()
    var arrowImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        textLabel.text = "나중에 정할래요"
        textLabel.font = .pretendardMedium(size: 18)
        textLabel.textColor = .secondary700
        arrowImageView.image = .arrowDown
        textLabel.backgroundColor = .clear
        arrowImageView.backgroundColor = .clear
        self.backgroundColor = .secondary850
        configureConstraint()
    }
    
    private func configureConstraint(){
        [textLabel,arrowImageView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        arrowImageView.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(arrowDownImageSize)
        }
        textLabel.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(labelToArrowDownPadding)
        }
    }

    func changeLabel(dateType: DateRange){
        textLabel.text = dateType.rawValue
    }
}
