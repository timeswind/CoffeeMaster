//
//  LocationCardView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

struct LocationCardView: View {
    var location: Location
    var showAnnotation: Bool
//    @State var annotations: [MGLPointAnnotation] = []
    @State var centerCoordinate: CLLocationCoordinate2D? = nil
    
    init(location: Location, showAnnotation: Bool = true) {
        self.location = location
        self.showAnnotation  = showAnnotation
    }
    
    func getAnnotationFromLocation() -> [MGLPointAnnotation] {
        let coordinate = location.coordinate.toCLCoordinate2D()
        let annotation = MGLPointAnnotation(title: self.location.name, coordinate: coordinate)
        return [annotation]
    }
    
    var body: some View {
        print("LocationCardView")
        print(self.location.coordinate)
        let center = self.location.coordinate.toCLCoordinate2D()
        
        let annotations = Binding<[MGLPointAnnotation]>(get: { () -> [MGLPointAnnotation] in
            if self.showAnnotation {
                return self.getAnnotationFromLocation()
            } else {
                return []
            }
        }) { (_) in }
        
        return VStack(alignment: .leading) {
            ThemeMapView(annotations: annotations, centerCoordinate: $centerCoordinate, center: center, regionDidChange: nil).zoomLevel(14).cornerRadius(5)
            Text(location.name)
                .font(.headline)
                .fontWeight(.bold)
        }.padding()
    }
}

struct LocationCardView_Previews: PreviewProvider {
    
    static var location: Location = Location(coordinate: Location.Coordinate(latitude: 34.435947, longitude: 108.757622), name: "Starbucks")
    static var previews: some View {
        LocationCardView(location: location).frame(height: 200).previewLayout(.sizeThatFits)
    }
}
