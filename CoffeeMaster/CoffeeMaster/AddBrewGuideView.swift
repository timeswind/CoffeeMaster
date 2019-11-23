//
//  AddBrewGuideView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/20/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct AddBrewGuideView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var keyboard: KeyboardResponder

    @State var baseBrewMethod: BrewMethod = chemexBrewMethod
    @State var guideName: String = ""
    @State var guideDescription: String = ""
    @State var guideIsPublic: Bool = false
    
    @State var brewStepGrindCoffee: BrewStepGrindCoffee?
    
    @State var brewStepBoilWater: BrewStepBoilWater?
    @State var brewSteps: [BrewStep] = []
    
    var coffeeWaterConfigured: Bool { return brewStepGrindCoffee != nil && brewStepBoilWater != nil}
    
    func exit() {
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    func finishedEditing() {
        
    }
    
    var body: some View {
        let defaultBrewMethods: [BrewMethod] = store.state.brewViewState.defaultBrewMethods
        
        return NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("ChooseBrewMethod"))) {
                    Picker(selection: $baseBrewMethod, label: Text(LocalizedStringKey("ChooseBrewMethod"))) {
                        ForEach(defaultBrewMethods, id: \.self) { method in
                            Text(LocalizedStringKey(method.name))
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text("You selected: \(baseBrewMethod.name)")
                }
                Section(header: Text(LocalizedStringKey("NewBrewGuideStepEdit"))) {
                    if (self.brewStepGrindCoffee == nil) {
                        NavigationLink(destination: ConfigureGrindCoffeeView(brewStepGrindCoffee: $brewStepGrindCoffee)) {
                            Text("Configure Coffee")
                        }
                    } else {
                        Text("Coffee Amount: \(self.brewStepGrindCoffee!.getCoffeeAmount())")
                        Text("Grind Type: \(self.brewStepGrindCoffee!.grindSize.rawValue)")
                    }
                    if (self.brewStepBoilWater == nil) {
                        NavigationLink(destination: ConfigureBoilWaterView(brewStepboilWater: $brewStepBoilWater)) {
                            Text("Configure Water")
                        }
                    } else {
                        Text("Brew Step Water")
                    }
                    
                    if (self.brewSteps.count > 0) {
                        ForEach(0..<self.brewSteps.count) { index in
                            Text(self.brewSteps[index].brewType.rawValue)
                        }
                    }
                    
                    NavigationLink(destination: AddBrewStepView(brewSteps: $brewSteps)) {
                        Text("Add Step")
                    }
                    
                    if (self.coffeeWaterConfigured) {
                        Text("Now we can add steps")
                    }
                }
                Section(header: Text(LocalizedStringKey("NewBrewGuideInfo"))) {
                    TextField(LocalizedStringKey("NewBrewGuideName"), text: $guideName)
                    MultilineTextField(LocalizedStringKey("NewBrewGuideDescription"), text: $guideDescription)
                    Toggle(isOn: $guideIsPublic) {
                        Text(LocalizedStringKey("NewBrewGuideIsPublicToggle"))
                    }
                }
                
            }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .navigationBarTitle(LocalizedStringKey("CreateBrewMethod"))
            .navigationBarItems(leading:
                    Button(action: {
                        self.exit()
                    }) {
                        Text(LocalizedStringKey("Dismiss"))
                },
                trailing:
                Button(action: {
                    self.finishedEditing()
                }) {
                    Text(LocalizedStringKey("Done"))
            })
        }.accentColor(Color(UIColor.Theme.Accent))
        
    }
}
