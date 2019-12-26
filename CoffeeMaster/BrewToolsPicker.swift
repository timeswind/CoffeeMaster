//
//  BrewToolsPicker.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

struct DefaultBrewTools {
    typealias Tool = BrewMethod.BrewTool
    static var chemexCoffeeMaker = Tool(count: 1, localizedNameKey: "ChemexCoffeemaker")
    static var chemexPaperFilter = Tool(count: 1, localizedNameKey: "ChemexPaperFilter")
    static var aeropressCoffeeMaker = Tool(count: 1, localizedNameKey: "AeropressCoffeemaker")
    static var aeropressPaperFilter = Tool(count: 1, localizedNameKey: "AeropressPaperFilter")
    static var hariov60Dripper = Tool(count: 1, localizedNameKey: "HarioV60Dripper")
    static var mokaPot = Tool(count: 1, localizedNameKey: "MokaPot")
    static var frenchPress = Tool(count: 1, localizedNameKey: "FrenchPress")
    static var paperFilter = Tool(count: 1, localizedNameKey: "PaperFilter")
    static var cup = Tool(count: 1, localizedNameKey: "Cup")
    static var kitchenScale = Tool(count: 1, localizedNameKey: "KitchenScale")
    static var spoon = Tool(count: 1, localizedNameKey: "Spoon")
    static var kettle = Tool(count: 1, localizedNameKey: "Kettle")
    static var stove = Tool(count: 1, localizedNameKey: "Stove")
}

class BrewToolsPicker {
    var brewTools: [BrewMethod.BrewTool] = []
    
    func pick(tool: BrewMethod.BrewTool) -> BrewToolsPicker {
        self.brewTools.append(tool)
        return self
    }
    
    func chemex() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.chemexCoffeeMaker)
        return self
    }
    
    func aeropress() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.aeropressCoffeeMaker)
        return self
    }
    
    func harioV60() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.hariov60Dripper)
        return self
    }
    
    func mokapot() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.mokaPot)
        return self
    }
    
    func frenchpress() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.frenchPress)
        return self
    }
    
    func stove() -> BrewToolsPicker  {
        self.brewTools.append(DefaultBrewTools.stove)
        return self
    }
    
    func aeropressFilter() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.aeropressPaperFilter)
        return self
    }
    
    func chemexFilter() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.chemexPaperFilter)
        return self
    }
    
    func paperFilter() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.paperFilter)
        return self
    }
    
    func cup() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.cup)
        return self
    }
    
    func scale() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.kitchenScale)
        return self
    }
    func spoon() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.spoon)
        return self
    }
    func kettle() -> BrewToolsPicker {
        self.brewTools.append(DefaultBrewTools.kettle)
        return self
    }
    func done() -> [BrewMethod.BrewTool] {
        return self.brewTools
    }
}
