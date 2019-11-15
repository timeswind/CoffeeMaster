//
//  ExploreView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var isSettingPresented: Bool = false

    func search() {
        print("search");
//        let setLanguageAction: AppAction = .settings(action: .setLocalization(localization: "en"))
//        store.send(setLanguageAction)
    }
    
    func showSettingsView() {
        isSettingPresented = true;
    }

    var body: some View {
        NavigationView {
        MapView().navigationBarTitle(Text(LocalizedStringKey("Explore"))).navigationBarItems(leading:
        
                            Button(action: {self.showSettingsView()}) {
                                Text("Settings")
                            },
                            trailing:
                                Button(action: {self.search()}) {
                                    Text(LocalizedStringKey("Search"))
                                })
        }.sheet(isPresented: $isSettingPresented) {
            SettingsView(showModal: self.$isSettingPresented, supportedLanguages: self.store.state.settings.supportedLanguages).environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }

    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
