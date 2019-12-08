//
//  FluidVolumn.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class FluidVolumn: Codable {
    private var weight:Double = 0
    
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
    
    func getVolumn() -> Double {
        return self.weight
    }
}
