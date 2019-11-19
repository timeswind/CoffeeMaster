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
    var instruction: String = ""
    var description: String = ""
    var duration: Int = 0
    var displayWeightUnit: WeightUnit?
    var displayTemperatureUnit: TemperatureUnit?
    
    init(brewType: BrewStepType) {
        self.brewType = brewType
    }
    
    func setDisplayWeightUnit(weightUnit: WeightUnit) {
        self.displayWeightUnit = weightUnit
    }
    
    func setDisplayTemperatureUnit(temperatureUnit: TemperatureUnit) {
        self.displayTemperatureUnit = temperatureUnit
    }
    
    func instruction(_ text: String) -> BrewStep {
        self.setInstruction(instruction: text)
        return self
    }
    
    func setInstruction(instruction: String) {
        self.instruction = instruction
    }
    
    func description(text: String) -> BrewStep {
        self.setDescription(description: text)
        return self
    }
    
    func duration(_ timeInSec: Int) -> BrewStep {
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
    private var coffeeAmount: Double = 0
    var grindSize: GrindSizeType = .Coarse
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .GrindCoffee)
        self.setDisplayWeightUnit(weightUnit: weightUnit)
    }
    
    func amount(coffeeInGram: Double) -> BrewStepGrindCoffee {
        self.setCoffeeAmount(coffeeAmount: coffeeInGram)
        return self
    }
    
    func grindSize(size: GrindSizeType) -> BrewStepGrindCoffee {
        self.setGrindSize(grindSize: size)
        return self
    }
    
    func setCoffeeAmount(coffeeAmount: Double) {
        switch self.displayWeightUnit {
        case .g:
            self.coffeeAmount = coffeeAmount
        case .oz:
            self.coffeeAmount = Utilities.OunceToGram(ounce: coffeeAmount)
        default:
            assert(false)
        }
    }
    
    func setGrindSize(grindSize: GrindSizeType) {
        self.grindSize = grindSize
    }
    
    func getCoffeeAmount() -> Double {
        switch self.displayWeightUnit {
        case .g:
            return self.coffeeAmount
        case .oz:
            return Utilities.gramToOunce(gram: self.coffeeAmount)
        default:
            assert(false, "Logic Error")
        }
    }
}

class BrewStepBoilWater: BrewStep {
    var waterTemperature: Double = 0
    var waterAmount: Double = 0
    
    init(weightUnit: WeightUnit, temperatureUnit: TemperatureUnit) {
        super.init(brewType: .BoilWater)
        self.setDisplayWeightUnit(weightUnit: weightUnit)
        self.setDisplayTemperatureUnit(temperatureUnit: temperatureUnit)
    }
    
    func water(_ amount: Double) -> BrewStepBoilWater {
        self.setWaterAmount(waterAmount: amount)
        return self
    }
    
    func temperatue(forWater temp: Double) ->BrewStepBoilWater {
        self.setWaterTemperature(waterTemperature: temp)
        return self
    }
    
    func setWaterAmount(waterAmount: Double) {
        switch self.displayWeightUnit {
        case .g:
            self.waterAmount = waterAmount
        case .oz:
            self.waterAmount = Utilities.OunceToGram(ounce: waterAmount)
        default:
            assert(false)
        }
    }
    
    func setWaterTemperature(waterTemperature: Double) {
        switch self.displayTemperatureUnit {
        case .C:
            self.waterTemperature = waterTemperature
        case .F:
            self.waterTemperature = Utilities.FahrenheitToCelsius(fahrenheit: waterTemperature)
        default:
            assert(false)
        }
    }
    
    func getWaterAmount() -> Double {
        switch self.displayWeightUnit {
        case .g:
            return self.waterAmount
        case .oz:
            return Utilities.gramToOunce(gram: self.waterAmount)
        default:
            assert(false, "Logic Error")
        }
    }
    
    func getWaterTemperature() -> Double {
        switch self.displayTemperatureUnit {
        case .C:
            return self.waterTemperature
        case .F:
            return Utilities.CelsiusToFahrenheit(celsius: self.waterTemperature)
        default:
            assert(false)
        }
    }
}

class BrewStepBloom: BrewStep {
    var waterAmount: Double = 0
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .Bloom)
        self.setDisplayWeightUnit(weightUnit: weightUnit)
    }
    
    func water(_ amount: Double) -> BrewStep {
        self.setWaterAmount(waterAmount: amount)
        return self
    }
    
    func setWaterAmount(waterAmount: Double) {
        switch self.displayWeightUnit {
        case .g:
            self.waterAmount = waterAmount
        case .oz:
            self.waterAmount = Utilities.OunceToGram(ounce: waterAmount)
        default:
            assert(false)
        }
    }
    
    func getWaterAmount() -> Double {
        switch self.displayWeightUnit {
        case .g:
            return self.waterAmount
        case .oz:
            return Utilities.gramToOunce(gram: self.waterAmount)
        default:
            assert(false, "Logic Error")
        }
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
    var amount: Double = 0
    
    init(weightUnit: WeightUnit) {
        super.init(brewType: .Other)
        self.displayWeightUnit = weightUnit
    }
    
    func amount(amountInGram: Double)-> BrewStepOther {
        self.setAmount(amount: amountInGram)
        return self
    }
    
    func setAmount(amount: Double) {
        switch self.displayWeightUnit {
        case .g:
            self.amount = amount
        case .oz:
            self.amount = Utilities.OunceToGram(ounce: amount)
        default:
            assert(false)
        }
    }
    
    func getAmount() -> Double {
        switch self.displayWeightUnit {
        case .g:
            return self.amount
        case .oz:
            return Utilities.gramToOunce(gram: self.amount)
        default:
            assert(false, "Logic Error")
        }
    }
}

