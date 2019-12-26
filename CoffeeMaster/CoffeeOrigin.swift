//
//  CoffeeOrigin.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum MonthInYears: String, Codable {
    case January = "January"
    case February = "February"
    case March = "March"
    case Aprial = "Aprial"
    case May = "May"
    case June = "June"
    case July = "July"
    case Auguest = "Auguest"
    case September = "September"
    case October = "October"
    case November = "November"
    case December = "December"
}

struct CoffeeGrowingRegion: Codable {
    var name: String
    var altitude: Double
    var harvestMonths: [MonthInYears]
    var varieties: [String]
}

class CoffeeOrigin: Codable {
    var continentName: String = ""
    var countryName: String = ""
    var tasteProfile: String = ""
    var population: Int = 0
    var coffeeGrowingRegions: [CoffeeGrowingRegion] = []
}
