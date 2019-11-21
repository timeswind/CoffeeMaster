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
                        NavigationLink(destination: ConfigureGrindCoffeeView(coffeeGrindSizeType: .Coarse, coffeeWeight: 0)) {
                            Text("Configure Coffee")
                        }
                    } else {
                        Text("Brew Step Coffee")
                    }
                    if (self.brewStepGrindCoffee == nil) {
                        NavigationLink(destination: Text("Configure Water")) {
                            Text("Configure Water")
                        }
                    } else {
                        Text("Brew Step Water")
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
                
            }.navigationBarTitle(LocalizedStringKey("CreateBrewMethod"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.exit()
                    }) {
                        Text(LocalizedStringKey("Dismiss"))
                })
        }.accentColor(Color(UIColor.Theme.Accent))
        
    }
}
