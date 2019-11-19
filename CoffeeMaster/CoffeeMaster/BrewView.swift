//
//  BrewSectionView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewView: View {
    @State var defaultBrewGuides: [BrewGuide] = []
    func fetch() {
        self.defaultBrewGuides = dependencies.defaultBrewingGuides.getGuides()
        print(self.defaultBrewGuides)
    }
    
    func showCreateBrewGuideForm() {
        
    }
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Brew")
            }.navigationBarTitle(Text(LocalizedStringKey("Brew"))).navigationBarItems(
                trailing:
                Button(action: {self.showCreateBrewGuideForm()}) {
                    Text("Add Button")
            }).onAppear(perform: fetch)
        }
    }
}
