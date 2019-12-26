//
//  CaffeineRecord.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/8/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CaffeineRecord: Codable {
    var caffeineEntry: CaffeineEntry
    var date: Timestamp!
    
    init(caffeineEntry: CaffeineEntry) {
        self.caffeineEntry = caffeineEntry
        self.date = Timestamp()
    }
}
