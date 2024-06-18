//
//  DateBottomSheetCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
import SnapKit
// Add / Edit 페이지에서 오늘까지/내일까지 Cell 용
class DateBottomSheetCollectionViewCell: UICollectionViewCell {
    static var identifier = "DateBottomSheetCollectionViewCell"
    var textLabel = UILabel()
    var imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    

    func configureUI(text: String, checked: Bool){
        textLabel.text = text
        textLabel.font = .pretendardRegular(size: 16)
        textLabel.textColor = .challendarWhite
        textLabel.sizeToFit()
        if checked {
            imageView.image = UIImage.check2
        }else{
            imageView.image = UIImage.check0
        }
        
        configureConstraint()
    }
    func changeImageforCustom(){
        imageView.image = UIImage.arrowRight
    }
    func configureConstraint(){
        [textLabel,imageView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(checkMarkVerticalPadding)
            $0.trailing.equalToSuperview().inset(checkMarkHorizontalPadding)
            $0.size.equalTo(24)
        }
        textLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(textLabelVerticalPadding)
            $0.trailing.equalTo(imageView.snp.leading).offset(6)
            $0.leading.equalToSuperview().offset(textLabelHorizontalPadding)
        }
        
    }
}
