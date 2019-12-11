//
//  Location.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

struct Location: Codable {
    var coordinate: Coordinate
    
    struct Coordinate: Codable {
        var latitude: Double
        var longitude: Double
    }
}
