//
//  CoffeeTastingTraits.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum CoffeeTastingTrait: String, Codable {
    
    case RoastColor = "RoastColor"
    case Aroma = "Aroma"
    case Defects = "Defects"
    case CleanCup = "CleanCup"
    case Sweet = "Sweet"
    case Acidity = "Acidity"
    case MouthFeel = "MouthFeel"
    case Flavor = "Flavor"
    case AfterTaste = "AfterTaste"
    case Balance = "Balance"
    case Overall = "Overall"
    
    var gradingType : GradingType {
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
    
    enum GradingType {
        case Text
        case Number
        case ScoreRange8
        case Aroma
    }
    
    static let allValues: [CoffeeTastingTrait] = [RoastColor, Aroma, Defects, CleanCup, Sweet, Acidity, MouthFeel, Flavor, AfterTaste, Balance, Overall]
}

class CoffeeTastingGrading {
    var coffeeTastingGradingType: CoffeeTastingTrait.GradingType
    var score: Int = 0
    
    init(_ coffeeTastingGradingType: CoffeeTastingTrait.GradingType) {
        self.coffeeTastingGradingType = coffeeTastingGradingType
    }
}

class CoffeeTastingGradingText: CoffeeTastingGrading {
    init() {
        super.init(.Text)
    }
}

class CoffeeTastingGradingNumber: CoffeeTastingGrading {
    init() {
        super.init(.Number)
    }
}

class CoffeeTastingGradingScoreRange8: CoffeeTastingGrading {
    init() {
        super.init(.ScoreRange8)
    }
}

class CoffeeTastingGradingAroma: CoffeeTastingGrading {
    init() {
        super.init(.Aroma)
    }
}


struct CoffeeTastingGradingSheet {
    var id: String?
    var created_by_uid: String?
    var created_at: Timestamp?
    var name: String?
    var descrtiption: String?
    var scores: [CoffeeTastingTrait: CoffeeTastingGrading]
}
