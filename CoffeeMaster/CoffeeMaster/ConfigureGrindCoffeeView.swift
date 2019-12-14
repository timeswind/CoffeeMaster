//
//  ConfigureGrindCoffeeView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

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
        let allWeightUnitTypes = WeightUnit.standardWeightUnitTypes
        
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
            
            VStack(alignment: .leading) {
                Section(header: HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "balance-scale-left", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureCoffeeAmountTitle")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }) {
                    
                    Text(LocalizedStringKey("ConfigureCoffeeAmountDescription"))
                        .padding(.vertical)
                }
                
                
                
                HStack {
                    FAText(iconName: "weight", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                Text(LocalizedStringKey("ConfigureCoffeeAmountInputTitle")).font(.headline).fontWeight(.bold)
                    
                    TextField(LocalizedStringKey("ConfigureCoffeeAmountInputTitle"), text: someNumberProxy)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: weightUnitValueBind, label: Text("ConfigureWeightUnitPickerLabel")) {
                        ForEach(allWeightUnitTypes, id: \.self) { grindType in
                            VStack {
                                Text(LocalizedStringKey(grindType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                
                HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "sliders-h", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ConfigureCoffeeGrindSizeTypeHeader")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }
                Picker(selection: $coffeeGrindSizeType, label: Text("ConfigureCoffeeGrindSizeTypePickerLabel")) {
                    ForEach(allGrindTypes, id: \.self) { grindType in
                        VStack {
                            Text(LocalizedStringKey(grindType.localizableString))
                        }
                    }
                    
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }.padding(.horizontal).navigationBarItems(trailing: Button(action: { self.submit() }) {
                Text(LocalizedStringKey("Done"))
            })
        
        
    }
}

struct ConfigureGrindCoffeeView_Previews: PreviewProvider {
    @State static var brewStepGrindCoffee: BrewStepGrindCoffee?
    
    static var previews: some View {
        ConfigureGrindCoffeeView(brewStepGrindCoffee: $brewStepGrindCoffee).modifier(EnvironmemtServices())
    }
}

