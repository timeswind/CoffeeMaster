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
    @State var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D.init()
    @State var selectLocationObjectIndex = 0
    @State var updatingCenterCoordinate = false
    
    let geocoder = Geocoder.shared
    
    private var onPickLocation: ((Location) -> Void)?
    private var onCancel: (() -> Void)?
    
    init (onPickLocation: ((Location) -> Void)? = nil, onCancel: (() -> Void)? = nil) {
        self.onPickLocation = onPickLocation
        self.onCancel = onCancel
    }
    
    func selectLocation(at Index: Int) {
        self.updatingCenterCoordinate = true
        self.centerCoordinate = self.locationObjects[Index].coordinate.toCLCoordinate2D()
        self.selectLocationObjectIndex = Index
    }
    
    private func mapRegionDidChange() {
        if (self.updatingCenterCoordinate) {
            self.updatingCenterCoordinate = false
        } else {
            self.selectLocationObjectIndex = -1
            if (self.searchText != "") {
                self.search()
            }
        }
    }
    
    
    func search() {
        let options = ForwardGeocodeOptions(query: self.searchText)
        options.allowedISOCountryCodes = ["US", "CN", "CA"]
        let latitude = self.centerCoordinate!.latitude
        let longitude = self.centerCoordinate!.longitude
        
        options.focalLocation = CLLocation(latitude: latitude, longitude: longitude)
        options.allowedScopes = [.place, .pointOfInterest, .landmark]

        geocoder.geocode(options) { (placemarks, attribution, error) in
            self.locationObjects = []
            self.annotations = []
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
    
    func cancel() {
        if let onCancel = self.onCancel {
            onCancel()
        }
    }
    
    func done() {
        if let onPickLocation = self.onPickLocation {
            if (self.selectLocationObjectIndex >= 0) {
                onPickLocation(self.locationObjects[self.selectLocationObjectIndex])
            } else {
                let location = Location(coordinate: Location.Coordinate(from: self.centerCoordinate!), name: "Customize Location", qualifiedName: nil)
                onPickLocation(location)
            }
        }
    }

    var body: some View {
        return         NavigationView {
            VStack {
            TextField(LocalizedStringKey("SearchPlace"), text: $searchText, onCommit: {
                self.search()
            }).modifier(ClearButton(text:$searchText))
        
                .padding()
                .background(Color.Theme.LightGrey)
                .cornerRadius(5.0)
                .padding()
                
                ThemeMapView(annotations: $annotations, centerCoordinate: $centerCoordinate, regionDidChange: {
                    self.mapRegionDidChange()
                })
                    .frame(height: 200).overlay(
                Image("icons8-marker-100")
            )
            
            List(0..<self.locationObjects.count, id:\.self) { index in
                LocationPickerListRowView(locationObject: self.locationObjects[index], isSelected: index == self.selectLocationObjectIndex).onTapGesture {
                    
                    self.selectLocation(at: index)
                }
            }
            
            Spacer()
        }.navigationBarItems(leading:
            Button(action: {
                self.cancel()
            }){
                Text(LocalizedStringKey("Cancel"))
            },
            trailing: Button(action: {
            self.done()
        }){
            Text(LocalizedStringKey("Done"))
        })
        .navigationBarTitle(LocalizedStringKey("LocationPicker"))
            }.accentColor(Color.Theme.Accent)

    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static func onPickLocation (_ location: Location) {
        print(location)
    }
    
    static var previews: some View {
            LocationPickerView(onPickLocation: { (location) in
                self.onPickLocation(location)
            }) {
                print("cancel")
            }
    }
}
