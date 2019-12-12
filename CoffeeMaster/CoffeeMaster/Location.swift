//
//  Location.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Mapbox

struct Location: Codable {
    var coordinate: Coordinate
    var name: String = ""
    
    struct Coordinate: Codable {
        var latitude: Double
        var longitude: Double
        
        func toCLCoordinate2D() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
