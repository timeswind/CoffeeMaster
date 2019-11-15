//
//  SettingsView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var selectedLanguage = 0
    @Binding var showModal: Bool
    
    var supportedLanguages: [String]
    
    func updateLocalization(select: Int) {
        var localization = "en"
        if (select == 1) {
            localization = "zh-Hans"
        }
        let updateAction: AppAction = .settings(action: .setLocalization(localization: localization))
        store.send(updateAction)
    }
        
    
    var body: some View {
        let p = Binding<Int>(get: {
            return self.selectedLanguage
        }, set: {
            self.selectedLanguage = $0
            self.updateLocalization(select: $0)
            // your callback goes here
        })
        
        return NavigationView{
            Form {
                Section {
                    Picker(selection: p, label: Text(LocalizedStringKey("ChooseLanguage"))) {
                        ForEach(0 ..< supportedLanguages.count, id: \.self) {
                            Text(self.supportedLanguages[$0]).tag($0)
                        }
                    }
                }
            }.navigationBarTitle(LocalizedStringKey("Settings"))
                .navigationBarItems(trailing:
                    Button(action: {self.showModal.toggle()}) {
                        Text("Dismiss")
                })
        }.environment(\.locale, .init(identifier: store.state.settings.localization))
    }
}
