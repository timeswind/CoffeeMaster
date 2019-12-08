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
    
    init() {
        StaticDataService.initilizaCaffeineEntries()
    }
    
    static func initilizaCaffeineEntries() {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "CaffeineEntries", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = JSONDecoder()
            self.caffeineEntries = try decoder.decode([CaffeineEntry].self, from: data)
//            print(self.caffeineEntries)
        } catch {
            // Handle error
            print(error)
            self.caffeineEntries = []
        }

    }

}
