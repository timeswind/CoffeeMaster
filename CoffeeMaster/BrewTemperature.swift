//
//  BrewTemperature.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum TemperatureUnit: String {
    case C = "°C"
    case F = "°F"
    
    static let allValues: [TemperatureUnit] = [C, F]
}

class BrewTemperature {
    private var temperature:Double = 0
    
    init() {
        self.temperature = 0
    }
    
    init(_ temperature: Double) {
        self.setTemperature(temperature: temperature)
    }
    
    func setTemperature(temperature: BrewTemperature) {
        self.temperature = temperature.getTemperature()
    }
    
    func setTemperature(temperature: Double) {
        let unit = getTemperatureUnit()
        switch unit {
        case .C:
            self.temperature = temperature
        case .F:
            self.temperature = Utilities.FahrenheitToCelsius(fahrenheit: temperature)
        }
    }
    func getTemperature() -> Double {
        let unit = getTemperatureUnit()
        switch unit {
        case .C:
            return self.temperature
        case .F:
            return Utilities.CelsiusToFahrenheit(celsius: self.temperature)
        }
    }
    
    func getCelsius() -> Double {
        return self.temperature
    }
}
