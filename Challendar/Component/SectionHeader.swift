//
//  SearchSectionHeader.swift
//  Challendar
//
//  Created by 서혜림 on 6/7/24.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardSemiBold(size: 14)
        label.textColor = .challendarBlack60
        return label
    }()
    
    let deleteLabel: UIButton = {
        let button = UIButton()
        button.setTitle("지우기", for: .normal)
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.titleLabel?.font = .pretendardSemiBold(size: 14)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        addSubview(deleteLabel)
        
        sectionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
