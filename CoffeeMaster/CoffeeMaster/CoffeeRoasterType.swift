//
//  CoffeeRoasterType.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum CoffeeRoasterType: String, Codable {
    case DRUM = "DRUM"
    case FLUID_BED = "FLUID_BED"
    case TANGENTIAL = "TANGENTIAL"
    case CENTRIFUGAL = "CENTRIFUGAL"
    
    var localizableString : String {
        switch self {
        case .DRUM: return "Drum Roaster"
        case .FLUID_BED: return "Fluid-bed Roaster"
        case .TANGENTIAL: return "Tangential Roaster"
        case .CENTRIFUGAL: return "Centrifugal Roaster"
        }
    }
    
    static let allValues: [CoffeeRoasterType] = [DRUM, FLUID_BED, TANGENTIAL, CENTRIFUGAL]
}
