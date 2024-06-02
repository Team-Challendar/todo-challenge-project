import UIKit

extension UITextField {
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        clearButton.tintColor = .challendarBlack60
        self.rightView = clearButton
        self.rightViewMode = mode
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        self.sendActions(for: .valueChanged)
    }
}
