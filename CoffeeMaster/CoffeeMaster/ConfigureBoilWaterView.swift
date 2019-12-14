//
//  ConfigureBoilWaterView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct ConfigureBoilWaterView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var brewStepBoilWater: BrewStepBoilWater?
    
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
        self.brewStepBoilWater = BrewStepBoilWater().water(self.waterAmount).temperatue(forWater: self.waterTemperature)
        print(self.waterAmount)
        print(self.waterTemperature)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let allWeightUnitTypes = WeightUnit.standardWeightUnitTypes
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
            VStack(alignment: .leading) {
                Section(header: HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "tint", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureBoilWaterTitle")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }) {
                    
                    Text(LocalizedStringKey("ConfigureBoilWaterDescription"))
                        .padding(.vertical)
                }
            
                
                
                HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "sliders-h", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureWaterAmountHeader")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }
                
                
                HStack {
                        FAText(iconName: "weight", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureWaterAmountInputTitle")).font(.headline).fontWeight(.bold)
                                    
                    
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
                        FAText(iconName: "temperature-high", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureWaterTemperatureInputTitle")).font(.headline).fontWeight(.bold)
                    
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
            }.padding(.horizontal).navigationBarItems(trailing: Button(action: { self.submit() }) {
                Text(LocalizedStringKey("Done"))
            })
        
        
    }
}

struct ConfigureBoilWaterView_Previews: PreviewProvider {
    @State static var brewStepBoilWater: BrewStepBoilWater?
    
    static var previews: some View {
        ConfigureBoilWaterView(brewStepBoilWater: $brewStepBoilWater).modifier(EnvironmemtServices())
    }
}

