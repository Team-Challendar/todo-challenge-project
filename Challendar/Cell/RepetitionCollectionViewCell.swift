//
//  RepetitionCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/21/24.
//

import UIKit
import SnapKit

class RepetitionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RepetitionCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .challendarWhite
        label.font = .pretendardRegular(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondary800.cgColor
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .challendarWhite
                label.textColor = .challendarBlack
                contentView.layer.borderWidth = 0
            } else {
                contentView.backgroundColor = .clear
                label.textColor = .challendarWhite
                contentView.layer.borderWidth = 1
            }
        }
    }
}
