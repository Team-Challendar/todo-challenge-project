// TodoSectionHeader.swift
import UIKit
import SnapKit

class TodoSectionHeader: UICollectionReusableView {
    static let identifier = "TodoSectionHeader"
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 14)
        label.textColor = .challendarBlack60
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraint() // setupViews 메서드를 configureConstraint로 변경
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraint() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            if let superview = superview {
                make.leading.equalTo(superview.safeAreaLayoutGuide.snp.leading).offset(16) // 화면 왼쪽 기준으로 16만큼 떨어지게 설정
            }
            make.centerY.equalToSuperview()
        }
    }
}
