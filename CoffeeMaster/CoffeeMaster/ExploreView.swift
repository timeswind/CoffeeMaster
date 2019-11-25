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
    @EnvironmentObject var environmentWindowObject: EnvironmentWindowObject
    @State var isSettingPresented: Bool = false
    
    func showSettingsView() {
        self.isSettingPresented = true;
    }

    var body: some View {
        NavigationView {
            ExploreMapView().navigationBarTitle(Text(LocalizedStringKey("Explore"))).navigationBarItems(leading:
                            Button(action: {self.showSettingsView()}) {
                                Text("Settings")
                            })
        }.sheet(isPresented: $isSettingPresented) {
            SettingsView(settingsState: self.store.state.settings).environmentObject(self.store).environmentObject(self.environmentWindowObject).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }

    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
