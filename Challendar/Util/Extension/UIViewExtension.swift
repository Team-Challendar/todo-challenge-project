import UIKit

extension UIView {
    func printConstraints() {
        print("Constraints for \(self):")
        for constraint in self.constraints {
            print(constraint)
        }
        
        if let superview = self.superview {
            for constraint in superview.constraints {
                if constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self {
                    print(constraint)
                }
            }
        }
    }
    
    
}
