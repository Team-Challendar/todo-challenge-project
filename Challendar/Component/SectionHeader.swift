//
//  SearchSectionHeader.swift
//  Challendar
//
//  Created by 서혜림 on 6/7/24.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    let sectionLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .red
        label.font = .pretendardSemiBold(size: 14)
        label.textColor = .challendarBlack60
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 리로드 데이터 할 때 diffable, hashable
