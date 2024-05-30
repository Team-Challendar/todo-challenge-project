import RAMAnimatedTabBarController
import UIKit

class CustomBounceAnimation : RAMItemAnimation {
    
    let selectedImage : UIImage
    let deSelectedImage : UIImage
    
    init(selectedImage : UIImage , deSelectedImage : UIImage) {
        self.selectedImage = selectedImage
        self.deSelectedImage = deSelectedImage
    }
    
    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        icon.tintColor = .challendarWhite100
        icon.image = selectedImage
    }
    
    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        icon.tintColor = .challendarBlack60
        icon.image = deSelectedImage
    }
    
    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        icon.tintColor = .challendarWhite100
        icon.image = selectedImage
    }
    
    override func deselectedState(_ icon: UIImageView,textLabel: UILabel) {
        icon.image = deSelectedImage
        
    }
    func playBounceAnimation(_ icon : UIImageView) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,0.8, 1.0]
        bounceAnimation.duration = 0.2
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}
