//
//  LocationPickerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/9/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox
import MapboxGeocoder

struct LocationPickerView: View {
    @State var searchText: String = ""
    @State var annotations: [MGLPointAnnotation] = []
    @State var placemarks: [GeocodedPlacemark] = []
    @State var centerLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    let geocoder = Geocoder.shared
    
    private var onPickLocation: ((Location) -> Void)?
    
    init (onPickLocation: ((Location) -> Void)? = nil) {
        self.onPickLocation = onPickLocation
    }
    
    func search() {
        let options = ForwardGeocodeOptions(query: self.searchText)
        options.allowedISOCountryCodes = ["US"]
        options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
        options.allowedScopes = [.address, .pointOfInterest]

        let task = geocoder.geocode(options) { (placemarks, attribution, error) in

            for placemark in placemarks! {
                print(placemark.name)
                    // 200 Queen St
                print(placemark.qualifiedName)
                    // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada

                let coordinate = placemark.location!.coordinate
                print("\(coordinate.latitude), \(coordinate.longitude)")
                    // 45.270093, -66.050985
            }
        }
    }
    
    func done() {
        print("Done")
        if let onPickLocation = self.onPickLocation {
            onPickLocation(Location(coordinate: Location.Coordinate(latitude: 0, longitude: 0)))
        }
    }

    var body: some View {
        return VStack {
            TextField(LocalizedStringKey("SearchPlace"), text: $searchText, onCommit: {
                self.search()
            })
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
        print(location)
    }
    
    static var previews: some View {
        NavigationView {
            LocationPickerView { (location) in
                self.onPickLocation(location)
            }
        }.accentColor(Color.Theme.Accent)
    }
}
