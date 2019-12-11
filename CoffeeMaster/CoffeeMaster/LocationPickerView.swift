//
//  LocationPickerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/9/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

struct LocationPickerView: View {
    @State var searchText: String = ""
    @State var annotations: [MGLPointAnnotation] = []
    
    private var onPickLocation: ((Location) -> Void)?
    
    init (onPickLocation: ((Location) -> Void)? = nil) {
        self.onPickLocation = onPickLocation
    }
    
    func done() {
        if let onPickLocation = self.onPickLocation {
            onPickLocation(Location(coordinate: Location.Coordinate(latitude: 0, longitude: 0)))
        }
    }

    var body: some View {
        return VStack {
            TextField(LocalizedStringKey("SearchPlace"), text: $searchText)
                .padding()
                .background(Color.Theme.LightGrey)
                .cornerRadius(5.0)
                .padding()
            ThemeMapView(annotations: $annotations).frame(height: 200).overlay(
                Image("icons8-marker-100")
            )
            Spacer()
        }.navigationBarItems(trailing: Button(action: {
            self.done()
        }){
            Text(LocalizedStringKey("Done"))
        })
        .navigationBarTitle(LocalizedStringKey("LocationPicker"))

    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static func onPickLocation (_ location: Location) {
        
    }
    
    static var previews: some View {
        NavigationView {
            LocationPickerView { (location) in
                self.onPickLocation(location)
            }
        }.accentColor(Color.Theme.Accent)
    }
}
