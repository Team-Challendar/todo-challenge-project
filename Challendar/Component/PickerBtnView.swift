import UIKit
import SnapKit

protocol PickerBtnViewDelegate: AnyObject {
    func didTapDailyButton()
}

class PickerBtnView: UIView {
    
    weak var delegate: PickerBtnViewDelegate?
    
    private let button1: UIButton = {
        let button = UIButton()
        button.setTitle("기한임박", for: .normal)
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .pretendardRegular(size: 17)
        return button
    }()
    
    private let button2: UIButton = {
        let button = UIButton()
        button.setTitle("등록순", for: .normal)
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .pretendardRegular(size: 17)
        return button
    }()
    
    private let button3: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.challendarBlack60, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .pretendardRegular(size: 17)
        return button
    }()
    
    private let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .challendarBlack60
        return view
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .challendarBlack60
        return view
    }()
    
    private var buttons: [UIButton] {
        return [button1, button2, button3]
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
        addSubview(button1)
        addSubview(button2)
        addSubview(button3)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        
        button1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        topSeparator.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.2) // 얇은 실선의 높이
        }
        
        bottomSeparator.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.2) // 얇은 실선의 높이
        }
        
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .black
    }
    
    private func setupActions() {
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(dailyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func dailyButtonTapped() {
        delegate?.didTapDailyButton()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons.forEach {
            $0.isSelected = false
            $0.tintColor = .challendarBlack60 // 기본 색상으로 되돌림
        }
        sender.isSelected = true
        sender.tintColor = .white // 선택된 버튼 색상 변경
    }
}

