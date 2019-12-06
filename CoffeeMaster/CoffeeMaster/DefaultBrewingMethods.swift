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
    var aeropressCoffeeMaker = Tool(count: 1, localizedNameKey: "AeropressCoffeemaker")
    var aeropressPaperFilter = Tool(count: 1, localizedNameKey: "AeropressPaperFilter")
    var cup = Tool(count: 1, localizedNameKey: "Cup")
    var kitchenScale = Tool(count: 1, localizedNameKey: "KitchenScale")
    var spoon = Tool(count: 1, localizedNameKey: "Spoon")
    var kettle = Tool(count: 1, localizedNameKey: "Kettle")
}

let chemexBrewMethodTools = BrewToolsPicker().chemex().chemexFilter().cup().scale().spoon().kettle().done()
let chemexBrewMethod = BrewMethod(.Chemex ,name: "Chemex", image: "chemex", descriptionKey: "ChemexDescription", brewTools: chemexBrewMethodTools)

let aeropressBrewMethodTools = BrewToolsPicker().aeropress().aeropressFilter().cup().scale().spoon().kettle().done()
let aeropressBrewMethod = BrewMethod(.AeroPress, name: "AeroPress", image: "aeropress", descriptionKey: "AeroPressDescription", brewTools: aeropressBrewMethodTools)

//let hariov60BrewMethod = BrewMethod(name: "Hario V60", image: "hariov60", descriptionKey: "HarioV60Description", description: nil)
//let mokapotBrewMethod = BrewMethod(name: "Moka Pot", image: "moka-pot", descriptionKey: "MokaPotDescription", description: nil)
//let FrenchPressBrewMethod = BrewMethod(name: "French Press", image: "french-press", descriptionKey: "FrenchPressDescription", description: nil)

class DefaultBrewingGuides {
    //Sample data fow preview and debug
    var sampleBrewSteps: [BrewStep] = []
    
    var guides: [BrewGuide] = []
    private var methods: [BrewMethod] = []
    
    init() {
        self.defaultChemex()
        self.defaultAeroPress()
    }
    
    func defaultChemex() {
        let grindCoffee = BrewStepGrindCoffee()
            .amount(25).grindSize(.Medium)
        let boilWater = BrewStepBoilWater()
            .water(340).temperatue(forWater: 94)
        
        let chemexBrewGuide = BrewGuide(baseBrewMethod: chemexBrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom().water(50).duration(10).instruction("Pour in 50ml of water and bloom for 10 secs"))
            .add(brewStep: BrewStepOther().instruction("Stir the grounds to ensure all coffee is fully immersed").duration(5))
            .add(brewStep: BrewStepOther().instruction("Wait for the coffee to bloom").duration(15))
            .add(brewStep: BrewStepBloom().water(130).instruction("Pour 130g of water in a spiral motion over the dark areas").duration(30))
            .add(brewStep: BrewStepWait().instruction("Wait for the water to drain through the grounds").duration(20))
            .add(brewStep: BrewStepBloom().water(160).instruction("Slowly top up the brewer with another 160g of water").duration(30))
            .add(brewStep: BrewStepOther().instruction("Wait for the water to drain through the grounds. When done remove the filter and serve").duration(20))
        
        chemexBrewGuide.guideDescription = "An iconic brewer with a timeless design invented in 1941, the Chemex is easy to use and easy on the eyes"
        chemexBrewGuide.guideName = chemexBrewMethod.name
        self.methods.append(chemexBrewMethod)
        self.guides.append(chemexBrewGuide)
        self.sampleBrewSteps = chemexBrewGuide.getBrewSteps()
    }
    
    func defaultAeroPress() {
        let grindCoffee = BrewStepGrindCoffee()
            .amount(15).grindSize(.Fine)
        let boilWater = BrewStepBoilWater()
            .water(240).temperatue(forWater: 94)
        
        let aeropressBrewGuide = BrewGuide(baseBrewMethod: aeropressBrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom().water(30).instruction("Pour 30g of water and evenly saturate the coffee").duration(10))
            .add(brewStep: BrewStepStir().instruction("Stir the grounds to ensure all coffee is fully immersed").duration(5))
            .add(brewStep: BrewStepOther().instruction("Wait for the coffee to bloom").duration(15))
            .add(brewStep: BrewStepBloom().water(210).instruction("Pour 210g of water in a spiral motion over the dark areas").duration(30))
            .add(brewStep: BrewStepOther().instruction("Place the plunger on the brewer and pull up slightly to create a pressure seal").duration(5))
            .add(brewStep: BrewStepWait().instruction("Wait fot the coffee to brew").duration(30))
            .add(brewStep: BrewStepOther().instruction("Gently press down on the plunger with steady pressure").duration(20))
            .add(brewStep: BrewStepOther().instruction("When done simply tale off the bottom cap, pop the grounds and the filter"))

        
        aeropressBrewGuide.guideDescription = "The AeroPress is the first coffee maker that combine affordability and simplicity with the ability to produce top quality coffee"
        aeropressBrewGuide.guideName = aeropressBrewMethod.name
        self.methods.append(aeropressBrewMethod)
        self.guides.append(aeropressBrewGuide)
    }
    
    func getGuides() -> [BrewGuide] {
        return self.guides
    }
    
    func getMethods() -> [BrewMethod] {
        return self.methods
    }
}
