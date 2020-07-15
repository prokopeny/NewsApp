import Foundation
import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat? = 10) {
        self.layer.cornerRadius = radius ?? 10
    }
    
    func dropShadow(color: UIColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func viewBorder(radius: CGFloat? = 10, width: CGFloat? = 1, color: CGColor) {
        self.layer.cornerRadius = radius ?? 10
        self.layer.borderWidth = width ?? 1
        self.layer.borderColor = color
    }
    
}

