//
//  ExploreView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import MapKit

struct ExploreView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var environmentWindowObject: EnvironmentWindowObject
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
        let state = self.store.state.exploreViewState
        let map_coordinate = Binding<CLLocationCoordinate2D>(get: { () -> CLLocationCoordinate2D in
            return state.map_coordinate
        }) { (isPresented) in
            
        }
        
        return NavigationView {
            ExploreMapView(coordinate: map_coordinate).navigationBarTitle(Text(LocalizedStringKey("Explore"))).navigationBarItems(leading:
                Button(action: {self.showSettingsView()}) {
                    Text("Settings")
                },
                                                                                                        trailing:
                Button(action: {self.search()}) {
                    Text(LocalizedStringKey("Search"))
            })
        }.sheet(isPresented: $isSettingPresented) {
            SettingsView(showModal: self.$isSettingPresented, settingsState: self.store.state.settings).environmentObject(self.store).environmentObject(self.environmentWindowObject).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
        
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
