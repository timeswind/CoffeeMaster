//
//  AddBrewStepView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct AddBrewStepView: View {
    @EnvironmentObject var keyboard: KeyboardResponder
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var brewSteps: [BrewStep]
    
    @State var brewStepType: BrewStepType = .Bloom
    @State var amount: Double = 0
    @State var duration:Int = 0
    @State var description:String = ""
    @State var instruction: String = ""
    
    func submit() {
        var newBrewStep: BrewStep!
        switch self.brewStepType {
        case .Bloom:
            newBrewStep = BrewStepBloom().water(self.amount).description(self.description).duration(self.duration)
        case .Stir:
            newBrewStep = BrewStepStir().description(self.description).duration(self.duration)
        case .Wait:
            newBrewStep = BrewStepWait().description(self.description).duration(self.duration)
        case .Other:
            newBrewStep = BrewStepOther().amount(self.amount).duration(self.duration).instruction(self.instruction).description(self.description)
        default:
            break
        }
        self.brewSteps.append(newBrewStep)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func update(weightUnit: WeightUnit) {
        let updateAction: AppAction = .settings(action: .setWeightUnit(weightUnit: weightUnit))
        store.send(updateAction)
    }
    
    var body: some View {
        let repeatBrewStepTypes = BrewStepType.repeatSteps
        let allWeightUnitTypes = WeightUnit.standardWeightUnitTypes
        
        let weightUnitValueBind = Binding<WeightUnit>(get: {
            return self.store.state.settings.weightUnit
        }, set: {
            self.update(weightUnit: $0)
        })
        
        let amountProxy = Binding<String>(
            get: {
                return String(format: "%.02f", Double(self.amount))
                
        },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.amount = value.doubleValue
                }
        }
        )
        
        let durationProxy = Binding<String>(
            get: {
                return String(format: "%d", Int(self.duration))
                
        },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.duration = value.intValue
                }
        }
        )
        
        return
            VStack(alignment: .leading) {
                Text("").padding(.top, 60)

                HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "tools", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ChooseTheStepType")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }
                
                VStack {
                    Picker(selection: $brewStepType, label: Text("AddBrewStepTypePickerLabel")) {
                        ForEach(repeatBrewStepTypes, id: \.self) { brewStepType in
                            VStack {
                                Text(LocalizedStringKey(brewStepType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                }
                .background(Color.white).cornerRadius(10)
                
                
                
                
                
                Text(LocalizedStringKey("EnterStepDetails")).font(.headline).fontWeight(.bold).padding(.top, 16)
                
                VStack(alignment: .leading) {
                    
                    
                    if (self.brewStepType == .Other) {
                        MultilineTextField(LocalizedStringKey("AddStepInstruction"), text: $instruction)
                    }
                    
                    if (self.brewStepType == .Bloom || self.brewStepType == .Other ) {
                        
                        HStack {
                            FAText(iconName: "weight", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("StepAmountTitle")).font(.headline).fontWeight(.bold)
                            
                            TextField(LocalizedStringKey("StepAmountTitle"), text: amountProxy)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .keyboardType(.decimalPad)
                            
                            Picker(selection: weightUnitValueBind, label: Text("StepAmountPickerLabel")) {
                                ForEach(allWeightUnitTypes, id: \.self) { grindType in
                                    VStack {
                                        Text(LocalizedStringKey(grindType.rawValue))
                                    }
                                }
                                
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    
                    HStack {
                        
                        FAText(iconName: "clock", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                        Text(LocalizedStringKey("StepDurationTitle")).font(.headline).fontWeight(.bold)
                        
                        
                        TextField(LocalizedStringKey("StepDurationTitle"), text: durationProxy)
                            .padding()
                            .foregroundColor(Color.black)
                            .keyboardType(.numberPad)
                        
                        
                    }.background(Color.white)
                    
                    MultilineTextField(LocalizedStringKey("AddStepDescription"), text: $description)
                    
                }.padding(.horizontal)
                    .background(Color.white).cornerRadius(10)
                Spacer()
                
            }.padding(.horizontal).navigationBarItems(trailing: Button(action: { self.submit() }) {
                Text(LocalizedStringKey("Done"))
            }).background(Color.Theme.TableViewGrey)
                .padding(.bottom, self.keyboard.currentHeight).animation(.easeInOut(duration: 0.16)).background(Color.Theme.TableViewGrey).edgesIgnoringSafeArea(.all)
    }
}

struct AddBrewStepView_Previews: PreviewProvider {
    @State static var brewSteps: [BrewStep] = []
    
    static var previews: some View {
        AddBrewStepView(brewSteps: $brewSteps).modifier(EnvironmemtServices())
    }
}

