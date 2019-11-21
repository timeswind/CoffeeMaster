//
//  BrewMethod.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

enum GrindSizeType {
    case Coarse
    case Medium
    case Fine
    case ExtraFine
    case Turkish
    
    var localizableString : String {
        switch self {
        case .Coarse: return "Coarse"
        case .Medium: return "Medium"
        case .Fine: return "Fine"
        case .ExtraFine: return "ExtraFine"
        case .Turkish: return "Turkish"
        }
    }
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

struct BrewMethod:Decodable, Hashable {
    var name: String
    var image: String
    var descriptionKey: String?
    var description: String?
    var brewTools: [BrewTool]?
    
    struct BrewTool: Decodable {
        var count: Int
        var localizedNameKey: String
    }
    
    static func == (lhs: BrewMethod, rhs: BrewMethod) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}


class BrewGuide {
    var guideName: String = ""
    var guideDescription: String = ""
    var isPublic: Bool = false
    var baseBrewMethod: BrewMethod!
    private var brewStepGrindCoffee: BrewStepGrindCoffee?
    private var brewStepBoilWater: BrewStepBoilWater?
    private var brewSteps: [BrewStep] = []
    
    init(baseBrewMethod: BrewMethod) {
        self.baseBrewMethod = baseBrewMethod
    }
    
    func createGuideWith(name: String) -> BrewGuide {
        self.guideName = name
        return self
    }
    
    func grindCoffee(step: BrewStepGrindCoffee) -> BrewGuide {
        self.brewStepGrindCoffee = step
        return self
    }
    
    func boilWater(step: BrewStepBoilWater) -> BrewGuide {
        self.brewStepBoilWater = step
        return self
    }
    
    func getBrewStepGrindCoffee() -> BrewStepGrindCoffee? {
        return self.brewStepGrindCoffee
    }
    
    func getBrewStepBoilWater() -> BrewStepBoilWater? {
        return self.brewStepBoilWater
    }
    
    func getBrewSteps() -> [BrewStep] {
        return self.brewSteps
    }
    
    func getBaseBrewMethod() -> BrewMethod {
        return self.baseBrewMethod
    }
    
    func add(brewStep: BrewStep) -> BrewGuide {
        if (self.brewStepBoilWater != nil && self.brewStepGrindCoffee != nil) {
            self.brewSteps.append(brewStep)
        } else {
            assert(true, "Logic Error")
        }
        return self
    }
    
    func removeBrewStep(at index: Int) {
        self.brewSteps.remove(at: index)
    }
    
    func changeBaseBrewMethod(to method: BrewMethod) {
        self.baseBrewMethod = method
    }
}
