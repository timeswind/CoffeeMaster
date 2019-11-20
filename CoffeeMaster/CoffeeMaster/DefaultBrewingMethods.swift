//
//  DefaultBrewingMethods.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

struct DefaultBrewTools {
    typealias Tool = BrewMethod.BrewTool
    var chemexCoffeeMaker = Tool(count: 1, localizedNameKey: "ChemexCoffeemaker")
    var chemexPaperFilter = Tool(count: 1, localizedNameKey: "ChemexPaperFilter")
    var cup = Tool(count: 1, localizedNameKey: "Cup")
    var kitchenScale = Tool(count: 1, localizedNameKey: "KitchenScale")
    var spoon = Tool(count: 1, localizedNameKey: "Spoon")
    var kettle = Tool(count: 1, localizedNameKey: "Kettle")
}

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
let chemexBrewMethodTools = BrewToolsPicker().chemex().chemexFilter().cup().scale().spoon().kettle().done()
let chemexBrewMethod = BrewMethod(name: "Chemex", image: "chemex-icon", descriptionKey: "ChemexDescription", description: nil, brewTools: chemexBrewMethodTools)

let aeropressBrewMethod = BrewMethod(name: "AeroPress", image: "aeropress-icon", descriptionKey: "AeroPressDescription", description: nil)
let hariov60BrewMethod = BrewMethod(name: "Hario V60", image: "hariov60-icon", descriptionKey: "HarioV60Description", description: nil)
let mokapotBrewMethod = BrewMethod(name: "Moka Pot", image: "mokapot-icon", descriptionKey: "MokaPotDescription", description: nil)
let FrenchPressBrewMethod = BrewMethod(name: "French Press", image: "frenchpress-icon", descriptionKey: "FrenchPressDescription", description: nil)

class DefaultBrewingGuides {
    var weightUnit: WeightUnit!
    var temperatureUnit: TemperatureUnit!
    private var guides: [BrewGuide] = []
    
    init(weightUnit: WeightUnit?, temperatureUnit: TemperatureUnit?) {
        self.weightUnit = weightUnit ?? .g
        self.temperatureUnit = temperatureUnit ?? .C
        self.defaultChemex()
    }
    
    func defaultChemex() {
        let grindCoffee = BrewStepGrindCoffee(weightUnit: weightUnit)
            .amount(coffeeInGram: 25).grindSize(size: .Medium)
        let boilWater = BrewStepBoilWater(weightUnit: weightUnit, temperatureUnit: temperatureUnit)
            .water(340).temperatue(forWater: 94)
        
        let chemexBrewGuide = BrewGuide(baseBrewMethod: chemexBrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom(weightUnit: weightUnit).water(50).duration(10))
            .add(brewStep: BrewStepOther(weightUnit: weightUnit).instruction("Stir the grounds to ensure all coffee is fully immersed").duration(5))
            .add(brewStep: BrewStepOther(weightUnit: weightUnit).instruction("Wait for the coffee to bloom").duration(15))
            .add(brewStep: BrewStepBloom(weightUnit: weightUnit).water(130).instruction("Pour 130g of water in a spiral motion over the dark areas").duration(30))
            .add(brewStep: BrewStepWait(weightUnit: weightUnit).instruction("Wait for the water to drain through the grounds").duration(20))
            .add(brewStep: BrewStepBloom(weightUnit: weightUnit).water(160).instruction("Slowly top up the brewer with another 160g of water").duration(30))
            .add(brewStep: BrewStepOther(weightUnit: weightUnit).instruction("Wait for the water to drain through the grounds. When done remove the filter and serve").duration(20))
        
        chemexBrewGuide.guideDescription = "An iconic brewer with a timeless design invented in 1941, the Chemex is easy to use and easy on the eyes"
        chemexBrewGuide.guideName = chemexBrewMethod.name
        self.guides.append(chemexBrewGuide)
    }
    
    func getGuides() -> [BrewGuide] {
        return self.guides
    }
}
