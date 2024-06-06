import UIKit

class TodoTitleTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setup(placeHolder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(placeHolder: "")
    }
    
    func setup(placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
        string: placeHolder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.challendarBlack60]
        )
        self.font = .pretendardMedium(size: 18)
        self.tintColor = .challendarGreen100
        self.textColor = .challendarWhite100
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.clearButtonMode = .never
        self.setClearButton(with: UIImage(systemName: "xmark.circle.fill")!, mode: .whileEditing)
    }
}

