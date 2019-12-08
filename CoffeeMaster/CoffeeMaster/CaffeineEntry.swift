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
        var volume: FluidVolume
        var caffeineAmount: BrewWeight
        
        enum CodingKeys: String, CodingKey {
            case volume, caffeineAmount
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let volumeValue = try values.decode(Double.self, forKey: .volume)
            let caffeineAmountValue = try values.decode(Double.self, forKey: .caffeineAmount)
            volume = FluidVolume(volumeValue)
            caffeineAmount = BrewWeight(caffeineAmountValue)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(volume.getVolumeInML(), forKey: .volume)
            try container.encode(caffeineAmount.getVolume(), forKey: .caffeineAmount)
        }
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
