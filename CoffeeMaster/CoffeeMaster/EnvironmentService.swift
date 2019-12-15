//
//  EnvironmentService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import HealthKit
import CoreData

struct EnvironmemtServices: ViewModifier {
        
    let context = EnvironmentManager.shared.context
    let store = EnvironmentManager.shared.store
    let keyboard = EnvironmentManager.shared.keyboard
    let localization = EnvironmentManager.shared.localization
    let window = EnvironmentManager.shared.window
    
    func body(content: Content) -> some View {
    
        return content
            .environment(\.managedObjectContext, context)
            .environmentObject(store)
            .environment(\.locale, .init(identifier: localization))
            .environmentObject(keyboard)
            .environmentObject(window)
            .accentColor(Color.Theme.Accent)
    }
}
