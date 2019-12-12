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
    @State var locationObjects: [Location] = []
    @State var placemarks: [GeocodedPlacemark] = []
    @State var centerLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    let geocoder = Geocoder.shared
    
    private var onPickLocation: ((Location) -> Void)?
    
    init (onPickLocation: ((Location) -> Void)? = nil) {
        self.onPickLocation = onPickLocation
    }
    
    private func mapRegionDidChange(_ centerCoordinate: CLLocationCoordinate2D) {
        self.centerLocation = centerCoordinate
        if (self.searchText != "") {
            self.search()
        }
    }
    
    func search() {
        let options = ForwardGeocodeOptions(query: self.searchText)
        options.allowedISOCountryCodes = ["US", "CN", "CA"]
        let latitude = self.centerLocation.latitude
        let longitude = self.centerLocation.longitude
        
        options.focalLocation = CLLocation(latitude: latitude, longitude: longitude)
        options.allowedScopes = [.place, .pointOfInterest, .landmark]

        geocoder.geocode(options) { (placemarks, attribution, error) in
            for placemark in placemarks! {
                if let location = placemark.location {
                    let locationObject = Location(coordinate: Location.Coordinate(from: location), name: placemark.name, qualifiedName: placemark.qualifiedName)
                    let annotation = MGLPointAnnotation(title: placemark.name, coordinate: location.coordinate)
                    self.locationObjects.append(locationObject)
                    self.annotations.append(annotation)
                }
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
            ThemeMapView(annotations: $annotations, regionDidChange: { center in
                self.mapRegionDidChange(center)
            }).frame(height: 200).overlay(
                Image("icons8-marker-100")
            )
            
            List(0..<self.locationObjects.count, id:\.self) { index in
                LocationPickerListRowView(locationObject: self.locationObjects[index])
            }
            
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
