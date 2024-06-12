//
//  SectionHeader.swift
//  Challendar
//
//  Created by 서혜림 on 6/7/24.
//

import UIKit
import SnapKit

protocol SectionHeaderDelegate: AnyObject {
    func didTapDeleteButton(in section: Int)
}

class SectionHeader: UICollectionReusableView {
    weak var delegate: SectionHeaderDelegate?
    var section: Int = 0
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium(size: 14)
        label.textColor = .secondary600
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("지우기", for: .normal)
        button.setTitleColor(.secondary600, for: .normal)
        button.titleLabel?.font = .pretendardMedium(size: 14)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        addSubview(deleteButton)
        
        sectionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(in: section)
    }
    
    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
