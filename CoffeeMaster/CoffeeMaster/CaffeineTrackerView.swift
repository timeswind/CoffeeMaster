//
//  CaffeineTrackerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import HealthKit
import QGrid

struct CaffeineTrackerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var selectedCategory: CaffeineEntry.Category?
    @State var selectedEntry: CaffeineEntry?
    
    var askPermission: Bool
    
    func selectCategory(_ category: CaffeineEntry.Category) {
        self.selectedCategory = category
    }
    
    func selectEntry(_ entry: CaffeineEntry) {
        self.selectedEntry = entry
    }
    
    func addRecord(_ entry: CaffeineEntry.Variation) {
        let healthStore = store.state.settings.heathStore!
        
        //Caffeine in mg
        let caffeineAmount = entry.caffeineAmount.getWeight() * 100
        
        let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)
        let quanitytUnit = HKUnit(from: "mg")
        let quantityAmount = HKQuantity(unit: quanitytUnit, doubleValue: caffeineAmount)
        let now = Date()
        let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: now, end: now)
        
        let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)
        
        let bloodCorrelationCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: now, end: now, objects: [sample])
        
        healthStore.save(bloodCorrelationCorrelationForWaterAmount, withCompletion: { (success, error) in
            if (error != nil) {
                print(error)
            } else {
                print("save success")
            }
            
        })
    }
    
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
        let caffeineEntries = askPermission ? store.state.recordViewState.caffeineEntries : StaticDataService.caffeineEntries
        
        return NavigationView {
            VStack {
                QGrid(caffeineEntries, columns: 3) { (entry) in
                    VStack {
                        Button(action: {
                            self.selectEntry(entry)
                        }){
                            Text(LocalizedStringKey(entry.name))
                        }
                        
                    }
                }
                
                if (selectedEntry != nil) {
                    QGrid(selectedEntry!.variation, columns: 3) { (entry) in
                        Button(action: {
                            if (self.askPermission) {
                                self.addRecord(entry)
                            }
                        }){
                            VStack {
                                Text(LocalizedStringKey(self.selectedEntry!.name))
                                Text("\(entry.volume.getVolumeInML())")
                                Text("\(entry.caffeineAmount.getVolume() * 100)mg")
                            }
                        }
                        
                        
                    }
                }
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
