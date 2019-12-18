//
//  ExploreView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

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
                    FAText(iconName: "user-cog", size: 22, style: .solid)
                }.accessibility(label: Text(LocalizedStringKey("Settings")))
            )
        }
        .sheet(isPresented: $isSettingPresented, onDismiss: {
            if (self.isSettingPresented == true) {
                self.isSettingPresented = false
            }
        }) {
            SettingsView(settingsState: self.store.state.settings).modifier(EnvironmemtServices())
        }
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView().modifier(EnvironmemtServices())
    }
}
