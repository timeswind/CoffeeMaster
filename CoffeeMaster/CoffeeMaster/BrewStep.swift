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
    var amount: BrewWeight = BrewWeight()

    private enum CodingKeys : String, CodingKey {
        case brewType, instruction, description, duration, amount
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brewType, forKey: .brewType)
        try container.encode(instruction, forKey: .instruction)
        try container.encode(description, forKey: .description)
        try container.encode(duration, forKey: .duration)
        try container.encode(amount.getVolumn(), forKey: .amount)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.brewType = try container.decode(BrewStepType.self, forKey: .brewType)
        self.instruction = try container.decode(String.self, forKey: .instruction)
        self.description = try container.decode(String.self, forKey: .description)
        self.duration = try container.decode(Int.self, forKey: .duration)
        let amountValue = try container.decode(Double.self, forKey: .amount)
        self.amount = BrewWeight(amountValue)
    }
    
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
    private enum CodingKeys: String, CodingKey { case coffeeAmount, grindSize }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coffeeAmount.getVolumn(), forKey: .coffeeAmount)
        try container.encode(grindSize, forKey: .grindSize)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let coffeeAmountInGram = try container.decode(Double.self, forKey: .coffeeAmount)
        let grindSize = try container.decode(GrindSizeType.self, forKey: .grindSize)
        
        self.coffeeAmount = BrewWeight(coffeeAmountInGram)
        self.grindSize = grindSize
    }
        
    init() {
        super.init(brewType: .GrindCoffee)
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
    
    private enum CodingKeys: String, CodingKey { case waterTemperature, waterAmount }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(waterTemperature.getCelsius(), forKey: .waterTemperature)
        try container.encode(waterAmount.getVolumn(), forKey: .waterAmount)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let waterTemperatureInCelsius = try container.decode(Double.self, forKey: .waterTemperature)
        let waterAmountInGram = try container.decode(Double.self, forKey: .waterAmount)
        
        self.waterTemperature = BrewTemperature(waterTemperatureInCelsius)
        self.waterAmount = BrewWeight(waterAmountInGram)
    }
    
    init() {
        super.init(brewType: .BoilWater)
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
        self.amount.setWeight(weight: waterAmount)
    }
    
    func getWaterAmount() -> BrewWeight {
        return self.amount
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

