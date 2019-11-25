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
        MainTabView().environment(\.locale, .init(identifier: store.state.settings.localization))
    }
}

struct MainTabView : View {
    @State private var selectedTabIndex = 1
    
    var body: some View {
        UIKitTabView([
            UIKitTabView.Tab(view: ExploreView(), title: NSLocalizedString("", comment: ""), image: "explore-icon-unselect-100"),
            UIKitTabView.Tab(view: BrewView(), title: NSLocalizedString("", comment: ""), image: "make-icon-unselect-100"),
            UIKitTabView.Tab(view: ConnectView(), title: NSLocalizedString("", comment: ""), image: "community-icon-unselect-100"),
            UIKitTabView.Tab(view: RecordView(), title: NSLocalizedString("", comment: ""), image: "record-icon-unselect-100")
        ], selectedIndex: $selectedTabIndex).accentColor(Color(UIColor.Theme.Accent))
    }
}
