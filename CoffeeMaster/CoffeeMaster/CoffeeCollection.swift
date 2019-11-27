//
//  CoffeeCollection.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct CoffeeCollection: Codable, Identifiable {
    var id: String?
    var images: [Image]?
    var created_by_user: String?
    var created_at: Timestamp?
    var updated_at: Timestamp?
    var coffeeOrigin: CoffeeOrigin
    var coffeeBeanType: CoffeeBeanType
    var coffeeTastingTrait: CoffeeTastingTrait
    
    private enum CodingKeys: String, CodingKey {
        case id, created_by_user, created_at, updated_at, coffeeOrigin, coffeeBeanType, coffeeTastingTrait
    }
}
