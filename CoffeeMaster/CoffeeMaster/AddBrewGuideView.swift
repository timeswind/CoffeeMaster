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
                Section(header: Text(LocalizedStringKey("NewBrewMethodInfo"))) {
                    TextField(LocalizedStringKey("NewBrewMethodName"), text: $guideName)
                    MultilineTextField(LocalizedStringKey("NewBrewMethodDescription"), text: $guideDescription)
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
