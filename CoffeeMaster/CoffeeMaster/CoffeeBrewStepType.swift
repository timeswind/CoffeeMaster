//
//  CoffeeBrewStepType.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class BrewStep {
    var brewType: BrewStepType!
    var description: String = ""
    var duration: Int = 0
    var weightUnit: WeightUnit?
    var temperatureUnit: TemperatureUnit?

    init(brewType: BrewStepType) {
        self.brewType = brewType
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    func setDuration(duration: Int) {
        self.duration = duration
    }
}

class BrewStepGrindCoffee: BrewStep {
    var coffeeAmount: Int = 0
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .GrindCoffee)
        self.weightUnit = weightUnit
    }
    
    func setCoffeeAmount(coffeeAmount: Int) {
        self.coffeeAmount = coffeeAmount
    }
}

class BrewStepBoilWater: BrewStep {
    var waterTemperature: Int = 0
    var waterAmount: Int = 0

    init(weightUnit: WeightUnit, temperatureUnit: TemperatureUnit) {
        super.init(brewType: .BoilWater)
        self.weightUnit = weightUnit
        self.temperatureUnit = temperatureUnit
    }
    
    func setWaterAmount(waterAmount: Int) {
        self.waterAmount = waterAmount
    }
    
    func setWaterTemperature(waterTemperature: Int) {
        self.waterTemperature = waterTemperature
    }
}

class BrewStepBloom: BrewStep {
    var waterAmount: Int = 0
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .Bloom)
        self.weightUnit = weightUnit
    }
    
    func setWaterAmount(waterAmount: Int) {
        self.waterAmount = waterAmount
    }
}

class BrewStepWait: BrewStep {
    init(weightUnit: WeightUnit) {
        super.init(brewType: .Wait)
    }
}

class BrewStepStir: BrewStep {
    init() {
        super.init(brewType: .Stir)
    }
}

class BrewStepOther: BrewStep {
    var amount: Int = 0

    var instruction: String = ""
    init() {
        super.init(brewType: .Other)
    }
    
    func setInstruction(instruction: String) {
        self.instruction = instruction
    }
    
    func setAmount(amount: Int) {
        self.amount = amount
    }
}

