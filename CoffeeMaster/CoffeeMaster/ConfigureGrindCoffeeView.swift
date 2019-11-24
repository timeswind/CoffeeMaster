//
//  ConfigureGrindCoffeeView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct ConfigureGrindCoffeeView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var brewStepGrindCoffee: BrewStepGrindCoffee?
    
    @State var coffeeGrindSizeType: GrindSizeType = .Coarse
    @State var coffeeAmount: Double = 0
    
//    var onDismiss: () -> Void
    
    var decimalFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .decimal
        return f
    }()
    
    func update(weightUnit: WeightUnit) {
        let updateAction: AppAction = .settings(action: .setWeightUnit(weightUnit: weightUnit))
        store.send(updateAction)
    }
    
    func submit() {
        self.brewStepGrindCoffee = BrewStepGrindCoffee().amount(self.coffeeAmount).grindSize(self.coffeeGrindSizeType)
        print(self.coffeeGrindSizeType.rawValue)
        print(self.coffeeAmount)
        
//        self.onDismiss()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let allGrindTypes = GrindSizeType.allValues
        let allWeightUnitTypes = WeightUnit.allValues
        
        let weightUnitValueBind = Binding<WeightUnit>(get: {
            return self.store.state.settings.weightUnit
        }, set: {
            self.update(weightUnit: $0)
        })
        
        let someNumberProxy = Binding<String>(
            get: {
                return String(format: "%.02f", Double(self.coffeeAmount))
        },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.coffeeAmount = value.doubleValue
                }
        }
        )
        
        return
            
            VStack {
                Section {
                    Text(LocalizedStringKey("ConfigureCoffeeAmountTitle"))
                    Text(LocalizedStringKey("ConfigureCoffeeAmountDescription"))
                }
                
                Text(LocalizedStringKey("ConfigureCoffeeAmountHeader"))
                
                HStack {
                    Text(LocalizedStringKey("ConfigureCoffeeAmountInputTitle"))
                    
                    TextField(LocalizedStringKey("ConfigureCoffeeAmountInputTitle"), text: someNumberProxy)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: weightUnitValueBind, label: Text("ConfigureGrindCoffee")) {
                        ForEach(allWeightUnitTypes, id: \.self) { grindType in
                            VStack {
                                Text(LocalizedStringKey(grindType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Text(LocalizedStringKey("ConfigureCoffeeGrindSizeTypeHeader"))
                
                Picker(selection: $coffeeGrindSizeType, label: Text("ConfigureCoffeeGrindSizeTypePickerLabel")) {
                    ForEach(allGrindTypes, id: \.self) { grindType in
                        VStack {
                            Text(LocalizedStringKey(grindType.localizableString))
                        }
                    }
                    
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }.navigationBarItems(trailing: Button(action: { self.submit() }) {
                Text(LocalizedStringKey("Done"))
            })
        
        
    }
}
