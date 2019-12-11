//
//  LocationPickerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/9/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct LocationPickerView: View {
    var body: some View {
        return VStack {
            
            ThemeMapView().frame(height: 200)
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerView()
    }
}
