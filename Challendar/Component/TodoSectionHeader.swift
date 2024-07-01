import UIKit
import SnapKit

class TodoSectionHeader: UICollectionReusableView {
    static let identifier = "TodoSectionHeader"
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 14)
        label.textColor = .secondary600
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("지우기", for: .normal) // 버튼 텍스트 설정
        button.setTitleColor(.secondary600, for: .normal) // 텍스트 색상을 .challendarBlack60으로 설정
        button.titleLabel?.font = .pretendardRegular(size: 14) // 폰트를 .pretendardRegular(size: 14)로 설정
        button.backgroundColor = .secondary900 // 배경색을 현재 배경과 동일하게 설정
        button.isHidden = true // 기본적으로는 숨김 상태로 설정
        button.sizeToFit() // 버튼의 크기를 텍스트에 맞게 조정
        return button
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
        addSubview(deleteButton)
    }
    
    private func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview() 
            make.centerY.equalToSuperview().offset(-5)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(headerLabel.snp.centerY) // headerLabel의 Y 좌표에 맞추도록 설정
        }
    }
    
    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
}

