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
    @State var annotations: [MGLPointAnnotation] = []
    @State var centerCoordinate: CLLocationCoordinate2D? = nil
    var body: some View {
        return VStack(alignment: .leading) {
            ThemeMapView(annotations: $annotations, centerCoordinate: $centerCoordinate, regionDidChange: nil)
                .centerCoordinate(location.coordinate.toCLCoordinate2D()).zoomLevel(16).cornerRadius(5)
            Text(location.name)
                .font(.headline)
                .fontWeight(.bold)
        }.padding()
    }
}

struct LocationCardView_Previews: PreviewProvider {
    static var location: Location = Location(coordinate: Location.Coordinate(latitude: 0, longitude: 0), name: "LocationName")
    static var previews: some View {
        LocationCardView(location: location).frame(height: 200).previewLayout(.sizeThatFits)
    }
}
