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
    case GrindCoffee = "GrindCoffee"
    case BoilWater = "BoilWater"
    case Bloom = "Bloom"
    case Wait = "Wait"
    case Stir = "Stir"
    case Other = "Other"
}

struct BrewMethod:Decodable {
    var name: String
    var image: String
    var description: String
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
