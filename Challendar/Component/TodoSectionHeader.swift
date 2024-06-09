import UIKit
import SnapKit

class TodoSectionHeader: UICollectionReusableView {
    static let identifier = "TodoSectionHeader"
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 14)
        label.textColor = .challendarBlack60
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(headerLabel)
    }
    
    private func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview() // leading을 superview에 맞추도록 설정
            make.centerY.equalToSuperview()
        }
    }
}

