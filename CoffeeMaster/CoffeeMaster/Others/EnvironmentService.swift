//
//  EnvironmentService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct EnvironmemtServices: ViewModifier {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let store = Store<AppState, AppAction>(initialState: AppState(settings: SettingsState(), repostate: ReposState(), connectViewState: ConnectViewState(), recordViewState: RecordViewState()), appReducer: appReducer)
    func body(content: Content) -> some View {
        print("EnvironmemtServices")
        let localization = getLocalization()
        store.send(.settings(action: .setLocalization(localization: localization)))
        
        if Auth.auth().currentUser != nil {
            store.send(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
            store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
        }
        
        return content
            .environment(\.managedObjectContext, context)
            .environmentObject(store)
            .environment(\.locale, .init(identifier: localization))
    }
}
