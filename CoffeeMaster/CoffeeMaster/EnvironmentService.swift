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

class EnvironmentManager {

    // MARK: - Properties

    static let shared = EnvironmentManager()

    // MARK: -

    let context: NSManagedObjectContext
    let store: Store<AppState, AppAction>
    let keyboard: KeyboardResponder
    let localization: String

    // Initialization

    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.store = Store<AppState, AppAction>(initialState: AppState(settings: SettingsState(),brewViewState: BrewViewState(), connectViewState: ConnectViewState(), recordViewState: RecordViewState()), appReducer: appReducer)
        self.keyboard = KeyboardResponder()
        
        self.localization = getLocalization()
        let weightUnit = getWeightUnit()
        let temperatureUnit = getTemperatureUnit()
        
        store.send(.settings(action: .setLocalization(localization: localization)))
        store.send(.settings(action: .setWeightUnit(weightUnit: weightUnit)))
        store.send(.settings(action: .setTemperatureUnit(temperatureUnit: temperatureUnit)))

        if Auth.auth().currentUser != nil {
            store.send(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
            store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            store.send(.settings(action: .enableHealthkit(store: healthStore)))
            
            var isAccessGranted = true
            for type in dependencies.requiredHeathKitTypes {
                let status = healthStore.authorizationStatus(for: type!)
                if status != .sharingAuthorized {
                    isAccessGranted = false
                    break
                }
            }
            
            if isAccessGranted {
                store.send(.settings(action: .healthDataAccessGranted(types: dependencies.requiredHeathKitTypes as! Set<HKSampleType>)))
            }
        }
        
        //initialize caffeineEntries
        store.send(.recordview(action: .setCaffeineEntries(caffeineEntries: StaticDataService.caffeineEntries)))
    }

}

struct EnvironmemtServices: ViewModifier {
    
//    let environmentManager = EnvironmentManager.shared
    
    let context = EnvironmentManager.shared.context
    let store = EnvironmentManager.shared.store
    let keyboard = EnvironmentManager.shared.keyboard
    let localization = EnvironmentManager.shared.localization
    
    func body(content: Content) -> some View {
    
        return content
            .environment(\.managedObjectContext, context)
            .environmentObject(store)
            .environment(\.locale, .init(identifier: localization))
            .environmentObject(keyboard)
    }
}
