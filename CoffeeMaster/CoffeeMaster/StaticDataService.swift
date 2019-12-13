//
//  StaticDataService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

class StaticDataService {
    static var caffeineEntries: [CaffeineEntry] = []
    static var defaultBrewGuides: [BrewGuide] = []
    static var defaultBrewMethods: [BrewMethod] = []
    
    
    init() {
        StaticDataService.initializeCaffeineEntries()
        StaticDataService.initializeDefaultBrewGuides()
    }
    
    static func initializeCaffeineEntries() {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "CaffeineEntries", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = JSONDecoder()
            StaticDataService.caffeineEntries = try decoder.decode([CaffeineEntry].self, from: data)
        } catch {
            // Handle error
            print(error)
            StaticDataService.caffeineEntries = []
        }
        
    }
    
    static func initializeDefaultBrewGuides() {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "DefaultBrewGuides", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = JSONDecoder()
            StaticDataService.defaultBrewGuides = try decoder.decode([BrewGuide].self, from: data)
            var defaultBrewMethods: [BrewMethod] = []
            
            for brewGuide in self.defaultBrewGuides {
                defaultBrewMethods.append(brewGuide.baseBrewMethod)
            }
            
            StaticDataService.defaultBrewMethods = defaultBrewMethods
            
            //            print(self.caffeineEntries)
        } catch {
            // Handle error
            print(error)
            StaticDataService.caffeineEntries = []
        }
    }
    
}
