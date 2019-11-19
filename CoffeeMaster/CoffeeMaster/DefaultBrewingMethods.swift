//
//  DefaultBrewingMethods.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

let chemexBrewMethod = BrewMethod(name: "Chemex", image: "chemex-icon", descriptionKey: "ChemexDescription", description: nil)
let aeropressBrewMethod = BrewMethod(name: "AeroPress", image: "aeropress-icon", descriptionKey: "AeroPressDescription", description: nil)
let hariov60BrewMethod = BrewMethod(name: "Hario V60", image: "hariov60-icon", descriptionKey: "HarioV60Description", description: nil)
let mokapotBrewMethod = BrewMethod(name: "Moka Pot", image: "mokapot-icon", descriptionKey: "MokaPotDescription", description: nil)
let FrenchPressBrewMethod = BrewMethod(name: "French Press", image: "frenchpress-icon", descriptionKey: "FrenchPressDescription", description: nil)

class DefaultBrewingMethods {
    var weightUnit: WeightUnit!
    var temperatureUnit: TemperatureUnit!
    var methods: [BrewGuide] = []
    
    init() {
        self.weightUnit = .g
        self.temperatureUnit = .C
    }
    
    func defaultChemex() {
        let grindCoffee = BrewStepGrindCoffee(weightUnit: self.weightUnit)
        grindCoffee.setCoffeeAmount(coffeeAmount: 25)
        grindCoffee.setGrindSize(grindSize: .Medium)
        
        let boilWater = BrewStepBoilWater(weightUnit: self.weightUnit, temperatureUnit: self.temperatureUnit)
        boilWater.setWaterAmount(waterAmount: 340)
        boilWater.setWaterTemperature(waterTemperature: 94)
        
        let chemexBrewGuide = BrewGuide(baseBrewMethod: chemexBrewMethod)
            .setBrewStepCoffee(step: grindCoffee)
            .setBrewStepWater(step: boilWater)

        
        self.methods.append(chemexBrewGuide)
    }
}
