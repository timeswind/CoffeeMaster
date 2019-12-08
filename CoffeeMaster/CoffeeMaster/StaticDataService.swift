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
        
    }

}
