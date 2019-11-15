//
//  EnvironmentService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct EnvironmemtServices: ViewModifier {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let store = Store<AppState, AppAction>(initialState: AppState(settings: SettingsState(), repostate: ReposState()), appReducer: appReducer)
    
    func body(content: Content) -> some View {
        print("EnvironmemtServices")
        let localization = getLocalization()
        
        store.send(.settings(action: .setLocalization(localization: localization)))
        
        return content
            .environment(\.managedObjectContext, context)
            .environmentObject(store)
            .environment(\.locale, .init(identifier: localization))
    }
}
