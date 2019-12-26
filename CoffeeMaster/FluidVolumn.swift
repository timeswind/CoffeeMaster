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
    private enum CodingKeys : String, CodingKey {
        case volume
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(volume, forKey: .volume)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.volume = try container.decode(Double.self, forKey: .volume)
    }
    
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
