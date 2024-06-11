import UIKit
import SnapKit

protocol PickerBtnViewDelegate: AnyObject {
    func didTapDailyButton()
}

class PickerBtnView: UIView {
    
    weak var delegate: PickerBtnViewDelegate?
    
    private let registeredOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("등록순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardRegular(size: 17)
        return button
    }()
    
    private let recentOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.secondary700, for: .normal)
        button.setTitleColor(.challendarWhite, for: .selected)
        button.titleLabel?.font = .pretendardRegular(size: 17)
        return button
    }()
    
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary700
        return view
    }()
    
    private var buttons: [UIButton] {
        return [registeredOrderBtn, recentOrderBtn]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(registeredOrderBtn)
        addSubview(recentOrderBtn)
        addSubview(separator)
        
        registeredOrderBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        recentOrderBtn.snp.makeConstraints { make in
            make.top.equalTo(registeredOrderBtn.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(recentOrderBtn.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .secondary850
    }
    
    private func setupActions() {
        //   button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        registeredOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        recentOrderBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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
        
        if sender == recentOrderBtn {
            delegate?.didTapDailyButton()
        }
    }
}

