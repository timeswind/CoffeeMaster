//
//  BrewToolsPicker.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class BrewToolsPicker {
    var brewTools: [BrewMethod.BrewTool] = []
    
    func pick(tool: BrewMethod.BrewTool) -> BrewToolsPicker {
        self.brewTools.append(tool)
        return self
    }
    
    func chemex() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().chemexCoffeeMaker)
        return self
    }
    
    func aeropress() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().aeropressCoffeeMaker)
        return self
    }
    
    func aeropressFilter() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().aeropressPaperFilter)
        return self
    }
    
    func chemexFilter() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().chemexPaperFilter)
        return self
    }
    
    func cup() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().cup)
        return self
    }
    
    func scale() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().kitchenScale)
        return self
    }
    func spoon() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().spoon)
        return self
    }
    func kettle() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools().kettle)
        return self
    }
    func done() -> [BrewMethod.BrewTool] {
        return self.brewTools
    }
}
