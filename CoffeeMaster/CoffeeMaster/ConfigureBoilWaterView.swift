//
//  ConfigureBoilWaterView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct ConfigureBoilWaterView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var brewStepboilWater: BrewStepBoilWater?
    
    @State var waterAmount: Double = 0
    @State var waterTemperature: Double = 0
    
    
    func update(weightUnit: WeightUnit) {
        let updateAction: AppAction = .settings(action: .setWeightUnit(weightUnit: weightUnit))
        store.send(updateAction)
    }
    
    func update(temperatureUnit: TemperatureUnit) {
        let updateAction: AppAction = .settings(action: .setTemperatureUnit(temperatureUnit: temperatureUnit))
        store.send(updateAction)
    }
    
    func submit() {
        self.brewStepboilWater = BrewStepBoilWater().water(self.waterAmount).temperatue(forWater: self.waterTemperature)
        print(self.waterAmount)
        print(self.waterTemperature)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let allWeightUnitTypes = WeightUnit.allValues
        let allTemperatureUnitTypes = TemperatureUnit.allValues
        
        
        let weightUnitValueBind = Binding<WeightUnit>(get: {
            return self.store.state.settings.weightUnit
        }, set: {
            self.update(weightUnit: $0)
        })
        
        let temperatureUnitValueBind = Binding<TemperatureUnit>(get: {
            return self.store.state.settings.temperatureUnit
        }, set: {
            self.update(temperatureUnit: $0)
        })
        
        let waterAmountProxy = Binding<String>(
            get: {
                return String(format: "%.02f", Double(self.waterAmount))
                
        },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.waterAmount = value.doubleValue
                }
        }
        )
        
        let waterTemperatureProxy = Binding<String>(
            get: {
                return String(format: "%.02f", Double(self.waterTemperature))
                
        },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.waterTemperature = value.doubleValue
                }
        }
        )
        
        return
            
            VStack {
                Section {
                    Text(LocalizedStringKey("ConfigureBoilWaterTitle"))
                    Text(LocalizedStringKey("ConfigureBoilWaterDescription"))
                }
                
                HStack {
                    Text(LocalizedStringKey("ConfigureWaterAmountInputTitle"))
                    
                    TextField(LocalizedStringKey("ConfigureWaterAmountInputTitle"), text: waterAmountProxy)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: weightUnitValueBind, label: Text("ConfigureWaterAmountPickerLabel")) {
                        ForEach(allWeightUnitTypes, id: \.self) { grindType in
                            VStack {
                                Text(LocalizedStringKey(grindType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                HStack {
                    Text(LocalizedStringKey("ConfigureWaterTemperatureInputTitle"))
                    
                    TextField(LocalizedStringKey("ConfigureWaterTemperatureInputTitle"), text: waterTemperatureProxy)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: temperatureUnitValueBind, label: Text("ConfigureWaterTemperaturePickerLabel")) {
                        ForEach(allTemperatureUnitTypes, id: \.self) { temperatureType in
                            VStack {
                                Text(LocalizedStringKey(temperatureType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Spacer()
            }.navigationBarItems(trailing: Button(action: { self.submit() }) {
                Text(LocalizedStringKey("Done"))
            })
        
        
    }
}
