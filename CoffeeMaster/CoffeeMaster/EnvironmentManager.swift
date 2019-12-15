//
//  EnvironmentManager.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import HealthKit
import CoreData

class EnvironmentManager {
    
    static let shared = EnvironmentManager()
    
    let context: NSManagedObjectContext
    let store: Store<AppState, AppAction>
    let keyboard: KeyboardResponder
    var localization: String
    var window: EnvironmentWindowObject = EnvironmentWindowObject.init(window: .init())
    
    static func addEnvironmentWindowObject(_ environmentWindowObject: EnvironmentWindowObject) {
        EnvironmentManager.shared.window = environmentWindowObject
    }
    
    static func updateLocalization(_ newLocalization: String) {
        EnvironmentManager.shared.localization = newLocalization
    }
    
    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.store = Store<AppState, AppAction>(initialState:
            AppState(settings: SettingsState(),
                     brewViewState: BrewViewState(),
                     connectViewState: ConnectViewState(),
                     recordViewState: RecordViewState()),
                                                appReducer: appReducer)
        
        self.keyboard = KeyboardResponder()
        
        self.localization = getLocalization()
        let weightUnit = getWeightUnit()
        let temperatureUnit = getTemperatureUnit()
        
        store.sendSync(.settings(action: .setLocalization(localization: localization)))
        store.sendSync(.settings(action: .setWeightUnit(weightUnit: weightUnit)))
        store.sendSync(.settings(action: .setTemperatureUnit(temperatureUnit: temperatureUnit)))
        
        if Auth.auth().currentUser != nil {
            store.sendSync(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
            store.sendSync(.settings(action: .setUserSignInStatus(isSignedIn: true)))
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
        //initialize default brew guides and methods
        store.send(.brewview(action: .setDefaultBrewGuides(guides: StaticDataService.defaultBrewGuides)))
        store.send(.brewview(action: .setDefaultBrewMethods(methods: StaticDataService.defaultBrewMethods)))
        
        
        // let test = DefaultBrewingGuides.init()
        
    }
    
}
