//
//  BrewSectionView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var isAddBrewGuideViewPresented = false
    
    func createBrewGuide() {
        self.isAddBrewGuideViewPresented = true
    }

    var body: some View {
        return NavigationView {
            BrewGuidsSelectionView().navigationBarTitle(Text(LocalizedStringKey("Brew"))).navigationBarItems(
                trailing:
                Button(action: {self.createBrewGuide()}) {
                    Text("Add Button")
            })
        }.sheet(isPresented: $isAddBrewGuideViewPresented) {
            AddBrewGuideView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct BrewGuidsSelectionView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
//    private func fetch() {
//        self.defaultBrewGuides = dependencies.defaultBrewingGuides.getGuides()
//    }
    
    var body: some View {
        let defaultBrewGuides = store.state.brewViewState.defaultBrewGuides
        
        return ScrollView(.vertical, showsIndicators: false) {
            if (defaultBrewGuides.count > 0) {
                ForEach(defaultBrewGuides, id: \.guideName) { brewGuide in
                    NavigationLink(destination: BrewGuideDetailView(brewGuide: brewGuide)) {
                        Text(brewGuide.guideName)
                    }
                }
            } else {
                EmptyView()
            }
        }

    }
}
