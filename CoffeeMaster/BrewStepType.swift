//
//  BrewStepType.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum BrewStepType: String, Codable {
    case GrindCoffee = "GrindCoffee"
    case BoilWater = "BoilWater"
    case Bloom = "Bloom"
    case Wait = "Wait"
    case Stir = "Stir"
    case Other = "Other"
    
    static var repeatSteps: [BrewStepType] = [Bloom, Wait, Stir, Other]
}
