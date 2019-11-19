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
    
    func description(text: String) -> BrewStep {
        self.setDescription(description: text)
        return self
    }
    
    func duration(timeInSec: Int) -> BrewStep {
        self.setDuration(duration: timeInSec)
        return self
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
    var grindSize: GrindSizeType = .Coarse
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .GrindCoffee)
        self.weightUnit = weightUnit
    }
    
    func coffeeAmount(amount: Int) -> BrewStepGrindCoffee {
        self.setCoffeeAmount(coffeeAmount: amount)
        return self
    }
    
    func grindSize(size: GrindSizeType) -> BrewStepGrindCoffee {
        self.setGrindSize(grindSize: size)
        return self
    }
    
    func setCoffeeAmount(coffeeAmount: Int) {
        self.coffeeAmount = coffeeAmount
    }
    
    func setGrindSize(grindSize: GrindSizeType) {
        self.grindSize = grindSize
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
    
    func water(amount: Int) -> BrewStepBoilWater {
        self.setWaterAmount(waterAmount: amount)
        return self
    }
    
    func temperatue(forWater temp: Int) ->BrewStepBoilWater {
        self.setWaterTemperature(waterTemperature: temp)
        return self
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
    
    func water(amount: Int) -> BrewStep {
        self.setWaterAmount(waterAmount: amount)
        return self
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
    
    func instruction(text: String) ->BrewStepOther {
        self.setInstruction(instruction: text)
        return self
    }
    
    func amount(amountInGram: Int)-> BrewStepOther {
        self.setAmount(amount: amountInGram)
        return self
    }
    
    func setInstruction(instruction: String) {
        self.instruction = instruction
    }
    
    func setAmount(amount: Int) {
        self.amount = amount
    }
}

