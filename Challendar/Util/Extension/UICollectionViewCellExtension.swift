//
//  UICollectionViewCellExtension.swift
//  Challendar
//
//  Created by Sam.Lee on 6/12/24.
//

import UIKit

extension UICollectionViewCell {
    func playBounceAnimation(_ icon : UIButton) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.8, 1.1, 1.0]
        bounceAnimation.duration = 0.2
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}
