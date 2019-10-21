//
//  Button+addShadow.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

extension UIButton {
   func addShadow() {
    let shadowSize : CGFloat = 5.0
    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                               y: (-shadowSize / 2) + 3,
                                               width: self.frame.size.width + shadowSize,
                                               height: self.frame.size.height + shadowSize))
    self.layer.masksToBounds = false
    self.layer.cornerRadius = 3
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.layer.shadowOpacity = 0.5
    self.layer.shadowPath = shadowPath.cgPath
    self.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
   }
}
