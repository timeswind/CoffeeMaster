//
//  BrewMethod.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum GrindSizeType: String {
    case Coarse = "Coarse"
    case Medium = "Medium"
    case Fine = "Fine"
    case ExtraFine = "ExtraFine"
    case Turkish = "Turkish"
}

enum WeightUnit: String {
    case g = "g"
    case oz = "oz"
}

enum TemperatureUnit: String {
    case C = "°C"
    case F = "°F"
}

enum BrewStepType: String {
    case Coffee = "Coffee"
    case Water = "Water"
}

struct BrewMethod:Decodable {
    var name: String
    var image: String
    var description: String
}

class BrewStep {
    var brewType: BrewStepType!
    
    init(brewType: BrewStepType) {
        self.brewType = brewType
    }
}

class BrewStepCoffee: BrewStep {
    var weightUnit: WeightUnit
    var coffeeAmount: Int = 0
    
    init(brewType: BrewStepType, weightUnit: WeightUnit) {
        self.weightUnit = weightUnit
        super.init(brewType: brewType)
    }
}

class BrewStepWater: BrewStep {
    var weightUnit: WeightUnit
    var temperatureUnit: TemperatureUnit
    var waterTemperature: Int = 0
    var waterAmount: Int = 0

    init(brewType: BrewStepType, weightUnit: WeightUnit, temperatureUnit: TemperatureUnit) {
        self.weightUnit = weightUnit
        self.temperatureUnit = temperatureUnit
        super.init(brewType: brewType)
    }
}


class BrewGuide {
    var guideName: String = ""
    var guideDescription: String = ""
    var isPublic: Bool = false
    var baseBrewMethod: BrewMethod!
    private var brewStepCoffee: BrewStepCoffee?
    private var brewStepWater: BrewStepWater?
    private var brewSteps: [BrewStep] = []
    
    init(baseBrewMethod: BrewMethod) {
        self.baseBrewMethod = baseBrewMethod
    }
    
    func setBrewStepCoffee(step: BrewStepCoffee) {
        self.brewStepCoffee = step
    }
    
    func setBrewStepWater(step: BrewStepWater) {
        self.brewStepWater = step
    }
    
    func getBrewSteps() -> [BrewStep] {
        return self.brewSteps
    }
    
    func add(brewStep: BrewStep) {
        if (self.brewStepWater != nil && self.brewStepCoffee != nil) {
            self.brewSteps.append(brewStep)
        } else {
            assert(true, "Logic Error")
        }
    }
    
    func removeBrewStep(at index: Int) {
        self.brewSteps.remove(at: index)
    }
}
