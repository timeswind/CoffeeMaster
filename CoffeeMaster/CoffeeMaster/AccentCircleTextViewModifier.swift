//
//  AccentCircleTextViewModifier.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct AccentCircleTextViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.frame(width: 100, height: 100, alignment: .center).background(Color(UIColor.Theme.Accent)).clipShape(Circle()).foregroundColor(.white)
    }
}
