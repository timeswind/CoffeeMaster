//
//  BrewGuide.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import FirebaseFirestore

class BrewGuide: Codable {
    var id: String?
    var created_by_uid: String?
    var guideName: String = ""
    var guideDescription: String = ""
    var isPublic: Bool = false
    var baseBrewMethod: BrewMethod!
    var created_at: Timestamp?
    
    private var brewStepGrindCoffee: BrewStepGrindCoffee?
    private var brewStepBoilWater: BrewStepBoilWater?
    private var brewSteps: [BrewStep] = []
    
    var coffeeWaterConfigured: Bool { return brewStepGrindCoffee != nil && brewStepBoilWater != nil}
    
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
    
    
    func getMaxiumBrewTimeInSec() -> Int {
        var total = 0
        for step in self.brewSteps {
            total += step.duration
        }
        return total
    }
}
