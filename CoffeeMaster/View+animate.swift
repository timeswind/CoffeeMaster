//
//  View+animate.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func animate(animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}
