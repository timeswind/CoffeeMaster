//
//  UIColor+ThemeColor.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    struct Theme {
        static let Accent = UIColor(netHex: 0x6D3D14)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Color {
    struct Theme {
        static let Accent = Color(UIColor.Theme.Accent)
        static let LightGrey = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
        static let TableViewGrey = Color(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    }
    
    init(red: Int, green: Int, blue: Int) {
        self.init(UIColor(red: red, green: green, blue: blue))
    }
    
    init(netHex:Int) {
        self.init(UIColor(netHex: netHex))
    }
}
