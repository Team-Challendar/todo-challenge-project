import UIKit
import SnapKit

class CustomPickerRowView: UIView {
    let textLabel: UILabel
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        super.init(frame: frame)
        self.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabelConstraints(for type: PickerType) {
        textLabel.snp.removeConstraints()
        if type == .hour {
            textLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-12)
                $0.top.bottom.equalToSuperview()
            }
        } else {
            textLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    func updateLabelStyle(highlighted: Bool) {
        if highlighted {
            textLabel.font = UIFont.pretendardSemiBold(size: 28)
            textLabel.textColor = .challendarWhite
        } else {
            textLabel.font = UIFont.pretendardSemiBold(size: 20)
            textLabel.textColor = .secondary700
        }
    }
}

enum PickerType {
    case hour
    case minute
}
