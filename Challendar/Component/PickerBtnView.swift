import UIKit
import SnapKit

protocol PickerBtnViewDelegate: AnyObject {
    func didTapLatestOrderButton()
    func didTapRegisteredOrderButton()
}

class PickerBtnView: UIView {
    
    weak var delegate: PickerBtnViewDelegate?
    
    private let registeredOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("등록순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardMedium(size: 17)
        return button
    }()
    
    private let latestOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardMedium(size: 17)
        return button
    }()
    
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary700
        return view
    }()
    
    private var buttons: [UIButton] {
        return [registeredOrderBtn, latestOrderBtn]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var buttonViews: [UIView] {
        return [registeredOrderBtn, latestOrderBtn]
    }
    private func addBorders() {
        for (index, buttonView) in buttonViews.enumerated() {
            if index > 0 {
                let border = UIView()
                border.backgroundColor = .secondary700
                buttonView.addSubview(border)
                border.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.height.equalTo(0.5) // 경계선의 높이
                }
            }
        }
    }
    
    private func setupView() {
        addSubview(registeredOrderBtn)
        addSubview(latestOrderBtn)
        
        registeredOrderBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        latestOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(registeredOrderBtn.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        addBorders()
        
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .secondary850
    }
    
    private func setupActions() {
        registeredOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        latestOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons.forEach {
            $0.isSelected = false
            $0.tintColor = .secondary850 // 기본 색상으로 되돌림
            $0.backgroundColor = .clear // 기본 배경색으로 되돌림
        }
        sender.isSelected = true
        sender.tintColor = .challendarWhite // 선택된 버튼 색상 변경
        sender.backgroundColor = .secondary850 // 선택된 버튼 배경색 변경
        
        if sender == latestOrderBtn {
            delegate?.didTapLatestOrderButton()
        } else if sender == registeredOrderBtn {
            delegate?.didTapRegisteredOrderButton()
        }
    }
    
}
