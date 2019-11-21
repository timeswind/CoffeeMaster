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

    @State var coffeeGrindSizeType: GrindSizeType = .Coarse
    @State var coffeeWeight: Double
    
    var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .decimal
        return f
    }()
    
    func update(weightUnit: WeightUnit) {
        let updateAction: AppAction = .settings(action: .setWeightUnit(weightUnit: weightUnit))
        store.send(updateAction)
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
            get: { String(format: "%.02f", Double(self.coffeeWeight)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.coffeeWeight = value.doubleValue
                }
            }
        )
        return
            Form {
                Section(header: Text(LocalizedStringKey("ConfigureCoffeeAmountHeader"))) {
                    HStack {
                        Text(LocalizedStringKey("ConfigureCoffeeAmountInputTitle"))

                        TextField("Total", value: $coffeeWeight, formatter: currencyFormatter)
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
                }

                Section(header: Text(LocalizedStringKey("ConfigureCoffeeGrindSizeTypeHeader"))) {
                    Picker(selection: $coffeeGrindSizeType, label: Text("ConfigureGrindCoffee")) {
                        ForEach(allGrindTypes, id: \.self) { grindType in
                            VStack {
                                Text(LocalizedStringKey(grindType.localizableString))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
        
    }
}
