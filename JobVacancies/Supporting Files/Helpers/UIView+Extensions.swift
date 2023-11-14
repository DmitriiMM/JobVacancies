//
//  UIView+Extensions.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import  UIKit

extension UIView {
    
    struct ShadowOptions {
        let color: UIColor
        let opacity: Float
        let sizeOfSet: CGSize
        let radius: CGFloat
        let spread: CGFloat
        
        internal init(color: UIColor, opacity: Float, sizeOfSet: CGSize, radius: CGFloat, spread: CGFloat = 0) {
            self.color = color
            self.opacity = opacity
            self.sizeOfSet = sizeOfSet
            self.radius = radius
            self.spread = spread
        }
    }
    
    func addShadow(_ options: ShadowOptions) {
        self.layer.shadowOpacity = options.opacity
        self.layer.shadowColor = options.color.cgColor
        self.layer.shadowOffset = options.sizeOfSet
        self.layer.shadowRadius = options.radius
        
        if options.spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -options.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
