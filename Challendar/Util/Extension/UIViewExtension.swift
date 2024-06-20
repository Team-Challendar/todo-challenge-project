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
    
    static func printSubviews(of view: UIView, level: Int = 0) {
            for (index, subview) in view.subviews.enumerated() {
                let indentation = String(repeating: "  ", count: level)
                print("\(indentation)Subview \(index): \(type(of: subview)), Frame: \(subview.frame)")
                
                // 재귀적으로 서브뷰의 서브뷰를 탐색
                printSubviews(of: subview, level: level + 1)
            }
        }
    
}
