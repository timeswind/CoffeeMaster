//
//  CaffeineTrackerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import HealthKit

struct CaffeineTrackerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var askPermission: Bool
    func checkPermission() {
        if (store.state.settings.isHealthKitEnabled == false) {
            // the app has no ability to add record into the health app
            // because the user's system doesn't support it
            print("Device not support")
            return
        }
        
        if (store.state.settings.isHealthDataAccessGranted == false) {
            let healthStore = store.state.settings.heathStore!
            let healthRecordTypes = dependencies.requiredHeathKitTypes as! Set<HKSampleType>
            healthStore.requestAuthorization(toShare: healthRecordTypes, read: healthRecordTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print("User denied access to health data")
                } else {
                    self.store.send(.settings(action: .healthDataAccessGranted(types: healthRecordTypes)))
                }
            }
            // Ask user permission to access health record and write health record
        } else {
            print("Have access to health data :)")
        }
    }
    
    var body: some View {
        return NavigationView {
            VStack {
                Text("Hello, World!")
            }.navigationBarTitle(Text(LocalizedStringKey("CaffeineTracker")))
        }.onAppear {
            if (self.askPermission) {
                self.checkPermission()
            }
        }
    }
}

struct CaffeineTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineTrackerView(askPermission: false)
    }
}
