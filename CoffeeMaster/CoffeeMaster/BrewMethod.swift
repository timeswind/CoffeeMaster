//
//  BrewMethod.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

enum GrindSizeType: String {
    case Coarse = "Coarse"
    case Medium = "Medium"
    case Fine = "Fine"
    case ExtraFine = "ExtraFine"
    case Turkish = "Turkish"
    
    var localizableString : String {
        switch self {
        case .Coarse: return "Coarse"
        case .Medium: return "Medium"
        case .Fine: return "Fine"
        case .ExtraFine: return "ExtraFine"
        case .Turkish: return "Turkish"
        }
    }
    
    static let allValues: [GrindSizeType] = [Coarse, Medium, Fine, ExtraFine, Turkish]
}

enum BaseBrewMethodType: String, Codable {
    case Chemex = "Chemex"
    case AeroPress = "AeroPress"
    case HarioV60 = "HarioV60"
    case MokaPot = "MokaPot"
    case FrenchPress = "FrenchPress"
    
    static var allBaseBrewMethods: [BaseBrewMethodType] = [Chemex, AeroPress, HarioV60, MokaPot, FrenchPress]
}

struct BrewMethod: Codable, Hashable {
    var baseBrewMethodType: BaseBrewMethodType!
    var name: String!
    var descriptionKey: String?
    var description: String?
    var brewTools: [BrewTool]?
    
    init(_ baseBrewMethodType: BaseBrewMethodType, name: String = "", image: String, descriptionKey: String = "", description: String = "", brewTools: [BrewTool] = []) {
        self.baseBrewMethodType = baseBrewMethodType
        self.name = name
        self.descriptionKey = descriptionKey
        self.description = description
        self.brewTools = brewTools
    }
    
    struct BrewTool: Codable {
        var count: Int
        var localizedNameKey: String
    }
    
    static func == (lhs: BrewMethod, rhs: BrewMethod) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
