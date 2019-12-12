//
//  LocationPickerListRowView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/12/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct LocationPickerListRowView: View {
    var locationObject: Location
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(locationObject.name).font(.headline).fontWeight(.heavy)
                Text(locationObject.qualifiedName ?? "").foregroundColor(Color.gray)
            }.padding()
            Spacer()
        }

    }
}

struct LocationPickerListRowView_Previews: PreviewProvider {
    static let location = Location(coordinate: Location.Coordinate.init(latitude: 9, longitude: 0), name: "LocationNAME", qualifiedName: "Location Address")
    
    static var previews: some View {
        LocationPickerListRowView(locationObject: location).previewLayout(.sizeThatFits)
    }
}
