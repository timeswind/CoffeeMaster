//
//  CaffeineTrackerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct CaffeineTrackerView: View {
    var body: some View {
        
        return NavigationView {
            VStack {
                Text("Hello, World!")
            }.navigationBarTitle(Text(LocalizedStringKey("CaffeineTracker")))
        }
    }
}

struct CaffeineTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineTrackerView()
    }
}
