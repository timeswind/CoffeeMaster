//
//  CaffeineEntry.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

struct CaffeineEntry: Codable {
    var category: Category
    var name: String
    var variation: [Variation]
    
    var image: Image?
    
    enum CodingKeys: String, CodingKey {
        case category
        case name
        case variation
    }
    
    struct Variation: Codable {
        var volumn: FluidVolume
        var caffeineAmount: BrewWeight
    }
    
    enum Category: String, Codable {
        case Coffee = "Coffee"
        case Espresso = "Espresso"
        case Tea = "Tea"
        case SoftDrink = "SoftDrink"
        case EnergyDrink = "EnergyDrink"
        
        static let allValues: [Category] = [Coffee, Espresso, Tea, SoftDrink, EnergyDrink]
    }
}
