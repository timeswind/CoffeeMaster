//
//  CoffeeBeanType.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum CoffeeBeanType: String, Codable {
    case Arabica = "Arabica"
    case Robusta = "Robusta"
    
    var localizableString : String {
        switch self {
        case .Arabica: return "Arabica"
        case .Robusta: return "Robusta"
        }
    }
    
    static let allValues: [CoffeeBeanType] = [Arabica, Robusta]
}
