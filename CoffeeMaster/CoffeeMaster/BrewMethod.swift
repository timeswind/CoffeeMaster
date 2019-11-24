//
//  BrewMethod.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

enum GrindSizeType: String {
    case Coarse = "Coarse"
    case Medium = "Medium"
    case Fine = "Fine"
    case ExtraFine = "ExtraFine"
    case Turkish = "Turkish"
    
    var localizableString : String {
        switch self {
        case .Coarse: return "Coarse"
        case .Medium: return "Medium"
        case .Fine: return "Fine"
        case .ExtraFine: return "ExtraFine"
        case .Turkish: return "Turkish"
        }
    }
    
    static let allValues: [GrindSizeType] = [Coarse, Medium, Fine, ExtraFine, Turkish]
}

enum WeightUnit: String {
    case g = "g"
    case oz = "oz"
    
    static let allValues: [WeightUnit] = [g, oz]
}

enum TemperatureUnit: String {
    case C = "°C"
    case F = "°F"
    
    static let allValues: [TemperatureUnit] = [C, F]
}

enum BrewStepType: String, Codable {
    case GrindCoffee = "GrindCoffee"
    case BoilWater = "BoilWater"
    case Bloom = "Bloom"
    case Wait = "Wait"
    case Stir = "Stir"
    case Other = "Other"
    
    static var repeatSteps: [BrewStepType] = [Bloom, Wait, Stir, Other]
}

enum BaseBrewMethodType: String, Codable {
    case Chemex = "Chemex"
    case AeroPress = "AeroPress"
    case HarioV60 = "HarioV60"
    case MokaPot = "MokaPot"
    case FrenchPress = "FrenchPress"
    
    static var allBaseBrewMethods: [BaseBrewMethodType] = [Chemex, AeroPress, HarioV60, MokaPot, FrenchPress]
}

struct BrewMethod: Codable, Hashable {
    var baseBrewMethodType: BaseBrewMethodType!
    var name: String!
    var image: String?
    var descriptionKey: String?
    var description: String?
    var brewTools: [BrewTool]?
    
    init(_ baseBrewMethodType: BaseBrewMethodType, name: String = "", image: String, descriptionKey: String = "", description: String = "", brewTools: [BrewTool] = []) {
        self.baseBrewMethodType = baseBrewMethodType
        self.name = name
        self.image = image
        self.descriptionKey = descriptionKey
        self.description = description
        self.brewTools = brewTools
    }
    
    struct BrewTool: Codable {
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


class BrewGuide: Codable {
    var id: String?
    var created_by_uid: String?
    var guideName: String = ""
    var guideDescription: String = ""
    var isPublic: Bool = false
    var baseBrewMethod: BrewMethod!
    private var brewStepGrindCoffee: BrewStepGrindCoffee?
    private var brewStepBoilWater: BrewStepBoilWater?
    private var brewSteps: [BrewStep] = []
    
    var coffeeWaterConfigured: Bool { return brewStepGrindCoffee != nil && brewStepBoilWater != nil}
    
    init(_ firebaseData:[String: Any]) {
        self.created_by_uid = firebaseData["created_by_uid"] as? String
        self.guideName = firebaseData["guideName"] as? String ?? ""
        self.guideDescription = firebaseData["guideDescription"] as? String ?? ""
        self.isPublic = firebaseData["isPublic"] as? Bool ?? false
    }
    
    init(baseBrewMethod: BrewMethod) {
        self.baseBrewMethod = baseBrewMethod
    }
    
    func description(_ description:String) -> BrewGuide {
        self.guideDescription = description
        return self
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
    
    func brewSteps(_ brewSteps: [BrewStep]) -> BrewGuide {
        self.brewSteps = brewSteps
        return self
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
