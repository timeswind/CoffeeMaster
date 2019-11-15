//
//  ExploreView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
    func search() {
        print("search");
    }

    var body: some View {
        NavigationView {
        MapView().navigationBarTitle(Text(LocalizedStringKey("Exlopre"))).navigationBarItems(leading:
        
                            Button(action: {self.search()}) {
                                Text("Quiz")
                            },
                            trailing:
                                Button(action: {self.search()}) {
                                    Text(LocalizedStringKey("Search"))
                                })
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
