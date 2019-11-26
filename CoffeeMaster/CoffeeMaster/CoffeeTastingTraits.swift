//
//  CoffeeTastingTraits.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum CoffeeTastingTraits {
    case RoastColor
    case Aroma
    case Defects
    case CleanCup
    case Sweet
    case Acidity
    case MouthFeel
    case Flavor
    case AfterTaste
    case Balance
    case Overall
    
    var gradingType : CoffeeTastingGradingType {
        switch self {
        case .RoastColor: return .Text
        case .Aroma: return .Aroma
        case .Defects: return .Number
        case .CleanCup: return .ScoreRange8
        case .Sweet: return .ScoreRange8
        case .Acidity: return .ScoreRange8
        case .MouthFeel: return .ScoreRange8
        case .Flavor: return .ScoreRange8
        case .AfterTaste: return .ScoreRange8
        case .Balance: return .ScoreRange8
        case .Overall: return .ScoreRange8
        }
    }
    
    static let allValues: [CoffeeTastingTraits] = [RoastColor, Aroma, Defects, CleanCup, Sweet, Acidity, MouthFeel, Flavor, AfterTaste, Balance, Overall]
}

enum CoffeeTastingGradingType {
    case Text
    case Number
    case ScoreRange8
    case Aroma
}
