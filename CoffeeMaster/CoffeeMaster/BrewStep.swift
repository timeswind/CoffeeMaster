//
//  CoffeeBrewStepType.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class BrewStep: Codable {
    var brewType: BrewStepType!
    var instruction: String = ""
    var description: String = ""
    var duration: Int = 0
    
    init(brewType: BrewStepType) {
        self.brewType = brewType
    }
    
    func instruction(_ text: String) -> BrewStep {
        self.setInstruction(instruction: text)
        return self
    }
    
    func setInstruction(instruction: String) {
        self.instruction = instruction
    }
    
    func description(_ text: String) -> BrewStep {
        self.setDescription(description: text)
        return self
    }
    
    func duration(_ timeInSec: Int) -> BrewStep {
        self.setDuration(duration: timeInSec)
        return self
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    func setDuration(duration: Int) {
        self.duration = duration
    }
}

class BrewStepGrindCoffee: BrewStep {
    private var coffeeAmount: BrewWeight = BrewWeight()
    var grindSize: GrindSizeType = .Coarse
    
    init() {
        super.init(brewType: .GrindCoffee)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func amount(_ coffeeInGram: BrewWeight) -> BrewStepGrindCoffee {
        self.setCoffeeAmount(coffeeAmount: coffeeInGram)
        return self
    }
    
    func amount(_ coffeeInGram: Double) -> BrewStepGrindCoffee {
        self.setCoffeeAmount(coffeeAmount: BrewWeight(coffeeInGram))
        return self
    }
    
    func grindSize(_ size: GrindSizeType) -> BrewStepGrindCoffee {
        self.setGrindSize(grindSize: size)
        return self
    }
    
    func setCoffeeAmount(coffeeAmount: BrewWeight) {
        self.coffeeAmount.setWeight(weight: coffeeAmount)
    }
    
    func setGrindSize(grindSize: GrindSizeType) {
        self.grindSize = grindSize
    }
    
    func getCoffeeAmount() -> BrewWeight {
        self.coffeeAmount
    }
}

class BrewStepBoilWater: BrewStep {
    var waterTemperature: BrewTemperature = BrewTemperature()
    var waterAmount: BrewWeight = BrewWeight()
    
    init() {
        super.init(brewType: .BoilWater)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func water(_ amount: BrewWeight) -> BrewStepBoilWater {
        self.setWaterAmount(waterAmount: amount)
        return self
    }
    
    func water(_ amount: Double) -> BrewStepBoilWater {
        self.setWaterAmount(waterAmount: BrewWeight(amount))
        return self
    }
    
    func temperatue(forWater temp: BrewTemperature) ->BrewStepBoilWater {
        self.setWaterTemperature(waterTemperature: temp)
        return self
    }
    
    func temperatue(forWater temp: Double) ->BrewStepBoilWater {
        self.setWaterTemperature(waterTemperature: BrewTemperature(temp))
        return self
    }
    
    func setWaterAmount(waterAmount: BrewWeight) {
        self.waterAmount.setWeight(weight: waterAmount)
    }
    
    func setWaterTemperature(waterTemperature: BrewTemperature) {
        self.waterTemperature.setTemperature(temperature: waterTemperature)
    }
    
    func getWaterVolumn() -> Double {
        return self.waterAmount.getVolumn()
    }
    
    func getWaterTemperature() -> BrewTemperature {
        return self.waterTemperature
    }
    
}

class BrewStepBloom: BrewStep {
    var waterAmount: BrewWeight = BrewWeight()
    
    init() {
        super.init(brewType: .Bloom)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func water(_ amount: BrewWeight) -> BrewStep {
        self.setWaterAmount(waterAmount: amount)
        return self
    }
    
    func water(_ amount: Double) -> BrewStep {
        self.setWaterAmount(waterAmount: BrewWeight(amount))
        return self
    }
    
    func setWaterAmount(waterAmount: BrewWeight) {
        self.waterAmount.setWeight(weight: waterAmount)
    }
    
    func getWaterAmount() -> BrewWeight {
        return self.waterAmount
    }
}

class BrewStepWait: BrewStep {
    init() {
        super.init(brewType: .Wait)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class BrewStepStir: BrewStep {
    init() {
        super.init(brewType: .Stir)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

class BrewStepOther: BrewStep {
    var amount: BrewWeight = BrewWeight()
    
    init() {
        super.init(brewType: .Other)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func amount(_ amountInGram: BrewWeight)-> BrewStepOther {
        self.setAmount(amount: amountInGram)
        return self
    }
    
    func amount(_ amountInGram: Double)-> BrewStepOther {
        self.setAmount(amount: BrewWeight(amountInGram))
        return self
    }
    
    func setAmount(amount: BrewWeight) {
        self.amount.setWeight(weight: amount)
    }
    
    func getAmount() -> BrewWeight {
        return self.amount
    }
}

