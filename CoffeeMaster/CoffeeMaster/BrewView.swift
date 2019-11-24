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
    @EnvironmentObject var keyboard: KeyboardResponder
    @State var isAddBrewGuideViewPresented = false
    
    private func fetchMyBrewGuides() {
        store.send(BrewViewAsyncAction.getMyBrewGuides(query: ""))
    }
    
    func createBrewGuide() {
        self.isAddBrewGuideViewPresented = true
    }
    
    var body: some View {
        return NavigationView {
            BrewGuidesSelectionView().navigationBarTitle(Text(LocalizedStringKey("Brew"))).navigationBarItems(
                trailing:
                Button(action: {self.createBrewGuide()}) {
                    Text("Add Button")
            }).onAppear(perform: fetchMyBrewGuides)
        }.sheet(isPresented: $isAddBrewGuideViewPresented) {
            AddBrewGuideView().environmentObject(self.store).environmentObject(self.keyboard).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct BrewGuidesSelectionView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    //    private func fetch() {
    //        self.defaultBrewGuides = dependencies.defaultBrewingGuides.getGuides()
    //    }
    
    var body: some View {
        let defaultBrewGuides = store.state.brewViewState.defaultBrewGuides
        let myBrewGuides = store.state.brewViewState.myBrewGuides
        
        return ScrollView(.vertical, showsIndicators: false) {
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading)  {
                if (myBrewGuides.count > 0) {
                    Text(LocalizedStringKey("MyBrewGuidesTitle")).font(.title)
                    
                    ForEach(myBrewGuides, id: \.guideName) { brewGuide in
                        NavigationLink(destination: BrewGuideDetailView(brewGuide: brewGuide)) {
                            Text(brewGuide.guideName)
                        }
                    }
                    
                } else {
                    EmptyView()
                }
                }.padding(.top)
                
                VStack(alignment: .leading)  {
                    if (defaultBrewGuides.count > 0) {
                        Text(LocalizedStringKey("DefaultBrewGuidesTitle")).font(.title)
                        
                        ForEach(defaultBrewGuides, id: \.guideName) { brewGuide in
                            NavigationLink(destination: BrewGuideDetailView(brewGuide: brewGuide)) {
                                Text(brewGuide.guideName)
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }.padding(.top)
            
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding([.horizontal])
            
        }
        
    }
}
