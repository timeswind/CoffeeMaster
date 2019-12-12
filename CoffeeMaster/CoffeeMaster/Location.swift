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
    var qualifiedName: String?
    
    enum CodingKeys: String, CodingKey {
        case coordinate, name, qualifiedName
    }
    
    struct Coordinate: Codable {
        var latitude: Double
        var longitude: Double
        
        init(from cllocation: CLLocation) {
            self.latitude = cllocation.coordinate.latitude
            self.longitude = cllocation.coordinate.longitude
        }
        
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        func toCLCoordinate2D() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

    }
}
