//
//  CoffeeBeanRoastingStage.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum CoffeeBeanRoastingStage {
    case raw_coffee
    case drying
    case yellowing
    case first_crack
    case roast_development
    case second_crack
    case developed
    
    static let allValues: [CoffeeBeanRoastingStage] = [raw_coffee, drying, yellowing, first_crack, roast_development, second_crack, developed]
}
