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
    let store = Store<AppState, AppAction>(initialState: AppState(settings: SettingsState(), repostate: ReposState(),brewViewState: BrewViewState(), connectViewState: ConnectViewState(), recordViewState: RecordViewState()), appReducer: appReducer)
    let keyboard = KeyboardResponder()
    func body(content: Content) -> some View {
        print("EnvironmemtServices")
        
        let localization = getLocalization()
        let weightUnit = getWeightUnit()
        let temperatureUnit = getTemperatureUnit()
        
        store.send(.settings(action: .setLocalization(localization: localization)))
        store.send(.settings(action: .setWeightUnit(weightUnit: weightUnit)))
        store.send(.settings(action: .setTemperatureUnit(temperatureUnit: temperatureUnit)))

        if Auth.auth().currentUser != nil {
            store.send(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
            store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
        }
        
        return content
            .environment(\.managedObjectContext, context)
            .environmentObject(store)
            .environment(\.locale, .init(identifier: localization))
            .environmentObject(keyboard)
    }
}
