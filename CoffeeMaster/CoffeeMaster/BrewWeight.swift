//
//  BrewWeight.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum WeightUnit: String, Codable {
    case g = "g"
    case oz = "oz"
    
    // Unit for caffeine
    case mg = "mg"
    // Unit for espresso
    case shot = "shot"

    static let standardWeightUnitTypes: [WeightUnit] = [g, oz]
}


class BrewWeight: Codable {
    private var weight:Double = 0
    private enum CodingKeys : String, CodingKey {
        case weight
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weight, forKey: .weight)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weight = try container.decode(Double.self, forKey: .weight)
    }
    
    init() {
        self.setWeight(weight: 0)
    }
    
    init(_ weight: Double) {
        self.setWeight(weight: weight)
    }
    
    func update() {
        let _ = getWeightUnit()
    }
    
    func setWeight(weight: BrewWeight) {
        self.weight = weight.getWeight()
    }
    
    func setWeight(weight: Double) {
        let unit = getWeightUnit()
        switch unit {
        case .g:
            self.weight = weight
        case .oz:
            self.weight = Utilities.OunceToGram(ounce: weight)
        default:
            return
        }
    }
    
    func getWeight() -> Double {
        let unit = getWeightUnit()
        switch unit {
        case .g:
            return self.weight
        case .oz:
            return Utilities.gramToOunce(gram: self.weight)
        default:
            return self.weight
        }
    }
    
    func getVolume() -> Double {
        return self.weight
    }
}
