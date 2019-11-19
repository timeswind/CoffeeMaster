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
    
    var body: some View {
        return NavigationView {
            BrewGuidsSelectionView().navigationBarTitle(Text(LocalizedStringKey("Brew"))).navigationBarItems(
                trailing:
                Button(action: {}) {
                    Text("Add Button")
            })
        }
    }
}

struct BrewGuidsSelectionView: View {
    @State var defaultBrewGuides: [BrewGuide] = []
    
    private func fetch() {
        self.defaultBrewGuides = dependencies.defaultBrewingGuides.getGuides()
    }
    
    var body: some View {
        
        return ScrollView(.vertical, showsIndicators: false) {
            if (self.defaultBrewGuides.count > 0) {
                ForEach(self.defaultBrewGuides, id: \.guideName) { brewGuide in
                    NavigationLink(destination: BrewGuideDetailView(brewGuide: brewGuide)) {
                        Text(brewGuide.guideName)
                    }
                }
            } else {
                EmptyView()
            }
        }.onAppear(perform: fetch)

    }
}
