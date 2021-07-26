//
//  UIViewExtension.swift
//  SavePhotos
//
//  Created by Tomashchik Daniil on 13/05/2021.
//

import Foundation
import UIKit

extension UIView{
    func dropShadow(_ radius: CGFloat = 15) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 2
        layer.cornerRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}
