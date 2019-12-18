//
//  ContentView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    var body: some View {
        MainTabView()
            .environment(\.locale, .init(identifier: store.state.settings.localization))
    }
}

struct MainTabView : View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    var body: some View {
        let selectedTabIndex = Binding<Int>(get: { () -> Int in
            return self.store.state.settings.mainTabViewSelectedTabIndex
        }) { (index) in
            self.store.send(.settings(action: .setMainTabViewSelectedTab(index: index)))
        }
        
        return UIKitTabView([
            UIKitTabView.Tab(view: ExploreView(), title: "Explore".localized(), image: "explore-icon-unselect-100"),
            UIKitTabView.Tab(view: BrewView(), title: "Brew".localized(), image: "make-icon-unselect-100"),
            UIKitTabView.Tab(view: ConnectView(), title: "Connect".localized(), image: "community-icon-unselect-100"),
            UIKitTabView.Tab(view: RecordView(), title: "Record".localized(), image: "record-icon-unselect-100")
        ], selectedIndex: selectedTabIndex).accentColor(Color(UIColor.Theme.Accent))
    }
}
