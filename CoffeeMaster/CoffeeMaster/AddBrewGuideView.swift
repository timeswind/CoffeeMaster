//
//  AddBrewGuideView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/20/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct AddBrewGuideView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var keyboard: KeyboardResponder
    
    @State var baseBrewMethod: BrewMethod = chemexBrewMethod
    @State var guideName: String = ""
    @State var guideDescription: String = ""
    @State var guideIsPublic: Bool = false
    
    @State var brewStepGrindCoffee: BrewStepGrindCoffee?
    @State var isBrewStepGrindCoffeeActive: Bool = false
    
    @State var brewStepBoilWater: BrewStepBoilWater?
    @State var brewSteps: [BrewStep] = []
    
    @State var showsAlert = false
    
    var coffeeWaterConfigured: Bool { return brewStepGrindCoffee != nil && brewStepBoilWater != nil}
    
    func exit() {
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    func formComplete() -> Bool {
        var result = true
        assert(store.state.settings.signedIn == true, "User Should have signed in")
        
        if (self.guideName.isBlank) { result = false; }
        if (self.guideDescription.isBlank) { result = false; }
        if (self.brewStepGrindCoffee == nil) { result = false; }
        if (self.brewStepBoilWater == nil) { result = false; }
        if (self.brewSteps.count == 0) { result = false; }
        
        return result
    }
    
    func finishedEditing() {
        if (!formComplete()) { print("Form not complete"); self.showsAlert = true; return }
        var newBrewGuide: BrewGuide =
            BrewGuide(baseBrewMethod: self.baseBrewMethod)
                .createGuideWith(name: self.guideName)
                .description(self.guideDescription)
                .setPublicStatus(self.guideIsPublic)
        newBrewGuide = newBrewGuide.boilWater(step: self.brewStepBoilWater!)
            .grindCoffee(step: self.brewStepGrindCoffee!)
            .brewSteps(self.brewSteps)
        
        newBrewGuide.created_by_uid = store.state.settings.uid!
        
        store.send(BrewViewAsyncAction.createBrewGuide(brewGuide: newBrewGuide))
    }
    
    var body: some View {
        let defaultBrewMethods: [BrewMethod] = store.state.brewViewState.defaultBrewMethods
        
        return NavigationView {
            Form {
                Section(header: HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "toolbox", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("ChooseBrewMethod")).font(.headline).fontWeight(.bold).padding(.top, 16)
                }) {
                    Picker(selection: $baseBrewMethod, label: Text(LocalizedStringKey("ChooseBrewMethod"))) {
                        ForEach(defaultBrewMethods, id: \.self) { method in
                            Text(LocalizedStringKey(method.name))
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text(LocalizedStringKey(baseBrewMethod.descriptionKey ?? ""))
                }
                Section(header: HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "list", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                Text(LocalizedStringKey("NewBrewGuideStepEdit")).font(.headline).fontWeight(.bold)
                }) {
                    if (self.brewStepGrindCoffee == nil) {
                        NavigationLink(destination: ConfigureGrindCoffeeView(brewStepGrindCoffee: $brewStepGrindCoffee)) {
                            Text("Configure Coffee")
                        }
                    } else {
                        Text("Coffee Amount: \(self.brewStepGrindCoffee!.getCoffeeAmount().getWeight())")
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
                        ForEach(0..<self.brewSteps.count, id: \.self) { index in
                            Text(self.brewSteps[index].brewType!.rawValue)
                        }
                    }
                    
                    if (self.coffeeWaterConfigured) {
                        NavigationLink(destination: AddBrewStepView(brewSteps: $brewSteps)) {
                            Text("Add Step")
                        }
                    }
                }
                Section(header: HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "info", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                    Text(LocalizedStringKey("NewBrewGuideInfo")).font(.headline).fontWeight(.bold)
                }) {
                    TextField(LocalizedStringKey("NewBrewGuideName"), text: $guideName)
                    MultilineTextField(LocalizedStringKey("NewBrewGuideDescription"), text: $guideDescription)
                    Toggle(isOn: $guideIsPublic) {
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: self.guideIsPublic ? "eye" : "eye-slash", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                        Text(LocalizedStringKey("NewBrewGuideIsPublicToggle")).fontWeight(.bold)
                        }
                    }
                }
                
            }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .navigationBarTitle(LocalizedStringKey("CreateBrewGuide"))
            .navigationBarItems(leading:
                Button(action: {
                    self.exit()
                }) {
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        FAText(iconName: "times", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                        Text(LocalizedStringKey("Dismiss")).fontWeight(.bold)
                    }
                },
                                trailing:
                Button(action: {
                    self.finishedEditing()
                }) {
                    HStack(alignment: .bottom, spacing: 0) {
                        FAText(iconName: "check", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                        Text(LocalizedStringKey("Done")).fontWeight(.bold)
                    }
                    
            })
                .alert(isPresented: self.$showsAlert, content: {
                    Alert(title: Text("Form not complete"))
                })
            
        }.accentColor(Color(UIColor.Theme.Accent))
    }
}

struct AddBrewGuideView_Previews: PreviewProvider {
    
    static var previews: some View {
           AddBrewGuideView().modifier(EnvironmemtServices())
    }
}
