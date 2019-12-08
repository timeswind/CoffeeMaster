//
//  FluidVolumn.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class FluidVolume: Codable {
    private var volume:Double = 0
    
    init() {
        self.setVolume(0)
    }
    
    init(_ volumnInML: Double) {
        self.setVolume(volumnInML)
    }
    
    func update() {
        let _ = getWeightUnit()
    }
    
    func setVolume(_ volume: BrewWeight) {
        self.volume = volume.getWeight()
    }
    
    func setVolume(_ volume: Double) {
        let unit = getWeightUnit()
        switch unit {
        case .g:
            self.volume = volume
        case .oz:
            self.volume = Utilities.OunceToGram(ounce: volume)
        default:
            return
        }
    }
    
    func getVolume() -> Double {
        let unit = getWeightUnit()
        switch unit {
        case .g:
            return self.volume
        case .oz:
            return Utilities.gramToOunce(gram: self.volume)
        default:
            return self.volume
        }
    }
    
    func getVolumeInML() -> Double {
        return self.volume
    }
}
