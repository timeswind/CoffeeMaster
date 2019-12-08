//
//  CaffeineEntry.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

enum CaffeineEntryCategory: String, Codable {
    case Coffee = "Coffee"
    case Espresso = "Espresso"
    case Tea = "Tea"
    case SoftDrink = "SoftDrink"
    case EnergyDrink = "EnergyDrink"
    case Medication = "Medication"
    
    static let allValues: [CaffeineEntryCategory] = [Coffee, Espresso, Tea, SoftDrink, EnergyDrink, Medication]
}

struct CaffeineEntryVariation: Codable {
    // Default Unit is mg
    var weight: String
    var weightUnit: WeightUnit = .mg
    var value: Int
    
    /* Example
     entryName: 8 fl oz
     
     */

}


struct CaffeineEntry: Codable {
    var category: CaffeineEntryCategory
    var name: String
    var variation: [CaffeineEntryVariation]
    
    var image: Image?
    
    enum CodingKeys: String, CodingKey {
        case category
        case name
        case variation
    }
}
