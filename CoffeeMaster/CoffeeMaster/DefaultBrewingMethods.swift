//
//  DefaultBrewingMethods.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

let chemexBrewMethodTools = BrewToolsPicker().chemex().chemexFilter().cup().scale().spoon().kettle().done()
let chemexBrewMethod = BrewMethod(.Chemex ,name: "Chemex", image: "chemex", descriptionKey: "ChemexDescription", brewTools: chemexBrewMethodTools)

let aeropressBrewMethodTools = BrewToolsPicker().aeropress().aeropressFilter().cup().scale().spoon().kettle().done()
let aeropressBrewMethod = BrewMethod(.AeroPress, name: "AeroPress", image: "aeropress", descriptionKey: "AeroPressDescription", brewTools: aeropressBrewMethodTools)

let hariov60BrewMethodTools = BrewToolsPicker().harioV60().paperFilter().cup().scale().spoon().kettle().done()
let hariov60BrewMethod = BrewMethod(.HarioV60, name: "Hario V60", image: "hariov60", descriptionKey: "HarioV60Description", brewTools: hariov60BrewMethodTools)

let mokapotBrewMethodTools = BrewToolsPicker().mokapot().cup().stove().kettle().done()
let mokapotBrewMethod = BrewMethod(.MokaPot, name: "Moka Pot", image: "moka-pot", descriptionKey: "MokaPotDescription", brewTools: mokapotBrewMethodTools)

let frenchPressBrewMethodTools = BrewToolsPicker().frenchpress().cup().scale().spoon().kettle().done()
let frenchPressBrewMethod = BrewMethod(.FrenchPress, name: "French Press", image: "french-press", descriptionKey: "FrenchPressDescription", brewTools: frenchPressBrewMethodTools)

class DefaultBrewingGuides {
    static var guides: [BrewGuide] = []
    
    init() {
        DefaultBrewingGuides.self.defaultChemex()
        DefaultBrewingGuides.self.defaultAeroPress()
        DefaultBrewingGuides.self.defaultHarioV60()
        DefaultBrewingGuides.self.defaultMokaPot()
        DefaultBrewingGuides.self.defaultFrenchPress()
        
        let jsonData = try! JSONEncoder().encode(DefaultBrewingGuides.guides)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
    }
    
    static func defaultFrenchPress() {
        let grindCoffee = BrewStepGrindCoffee()
            .amount(30).grindSize(.Medium)
        let boilWater = BrewStepBoilWater()
            .water(350).temperatue(forWater: 94)
        
        let frenchPressBrewGuide = BrewGuide(baseBrewMethod: frenchPressBrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom().water(60).instruction("Pour 60g of water and evenly saturate the coffee").duration(10))
            .add(brewStep: BrewStepStir().instruction("Gently stir the grounds to ensure all coffee is immersed").duration(5))
            .add(brewStep: BrewStepWait().instruction("Wait for the coffee to bloom").duration(15))
            .add(brewStep: BrewStepBloom().water(290).instruction("Pour the remaining 290g of water in a spiral motion").duration(30))
            .add(brewStep: BrewStepWait().instruction("Allow the coffee to steep for 3 minutes").duration(180))
            .add(brewStep: BrewStepOther().instruction("Gently press the filter down and serve in a warm cup").duration(5))
            
        
        frenchPressBrewGuide.guideDescription = "A French Press is a coffee brewing device patented by italian designer Attilio Camlimani in 1929"
        frenchPressBrewGuide.guideName = frenchPressBrewMethod.name
        DefaultBrewingGuides.guides.append(frenchPressBrewGuide)
    }
    
    static func defaultMokaPot() {
        let grindCoffee = BrewStepGrindCoffee()
            .amount(18).grindSize(.Medium)
        let boilWater = BrewStepBoilWater()
            .water(200).temperatue(forWater: 94)
        
        let mokaPotBrewGuide = BrewGuide(baseBrewMethod: mokapotBrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom().water(200).instruction("Fill the lower chamber with boiling water just below the valve").duration(5))
            .add(brewStep: BrewStepOther().instruction("Insert the funnel and fill it with ground coffee").duration(5))
            .add(brewStep: BrewStepOther().instruction("Tightly screw the upper part of the pot on to the base").duration(5))
            .add(brewStep: BrewStepOther().instruction("Put the brewer on a stove and turn on medium heat").duration(5))
            .add(brewStep: BrewStepWait().instruction("Wait approx. 5 to 6 minutes for the water to boil").duration(300))
            .add(brewStep: BrewStepOther().instruction("Once the top of the pot is full, remove from the stove and pour into a cup. Enjoy!").duration(10))
            
        
        mokaPotBrewGuide.guideDescription = "The Moka Pot, also know as a macchinetta(literally\"small machine\"), is a stove_top or electric coffee maker that produces coffee by passing boiling water pressurized by steam through ground coffee."
        mokaPotBrewGuide.guideName = mokapotBrewMethod.name
        DefaultBrewingGuides.guides.append(mokaPotBrewGuide)
    }
    
    static func defaultHarioV60() {
        let grindCoffee = BrewStepGrindCoffee()
            .amount(13).grindSize(.Medium)
        let boilWater = BrewStepBoilWater()
            .water(220).temperatue(forWater: 94)
        
        let harioV60BrewGuide = BrewGuide(baseBrewMethod: hariov60BrewMethod)
            .grindCoffee(step: grindCoffee)
            .boilWater(step: boilWater)
            .add(brewStep: BrewStepBloom().water(50).duration(10).instruction("Pour 50g of water until all the grounds are evenly saturated"))
            .add(brewStep: BrewStepWait().duration(20).instruction("Wait for the coffee to bloom"))
            .add(brewStep: BrewStepBloom().water(50).instruction("Pour another 50g of water in spiral rotation").duration(10))
            .add(brewStep: BrewStepWait().instruction("Wait for the water to drain through the grounds").duration(20))
            .add(brewStep: BrewStepBloom().water(120).instruction("Pour the remaining 120g of water around the edges of the dripper").duration(40))
            .add(brewStep: BrewStepWait().instruction("Let the water drain through and when it's done, discard the filter and serve").duration(15))

            
        
        harioV60BrewGuide.guideDescription = "The Hario V60 is the first coffee maker that combines affordability and simplicity with the ability to produce top quality coffee"
        harioV60BrewGuide.guideName = hariov60BrewMethod.name
        DefaultBrewingGuides.guides.append(harioV60BrewGuide)
        
    }
    
    static func defaultChemex() {
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
        DefaultBrewingGuides.guides.append(chemexBrewGuide)
    }
    
    static func defaultAeroPress() {
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
        DefaultBrewingGuides.guides.append(aeropressBrewGuide)
        
//        let jsonData = try! JSONEncoder().encode(aeropressBrewGuide)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)
    }
}
