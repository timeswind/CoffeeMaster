//
//  EnvironmentWindowKey.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

class EnvironmentWindowObject: ObservableObject {
    @Published var window: UIWindow = nil
    
    init(window: UIWindow) {
        self.window = window
    }
}
