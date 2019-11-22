//
//  AddBrewStepView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct AddBrewStepView: View {
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
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        let repeatBrewStepTypes = BrewStepType.repeatSteps
        
        return VStack {
            Picker(selection: $brewStepType, label: Text("AddBrewStepTypePickerLabel")) {
                ForEach(repeatBrewStepTypes, id: \.self) { brewStepType in
                    VStack {
                        Text(LocalizedStringKey(brewStepType.rawValue))
                    }
                }
                
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
        }.navigationBarItems(trailing: Button(action: { self.submit() }) {
            Text(LocalizedStringKey("Done"))
        })
        
        
    }
}
