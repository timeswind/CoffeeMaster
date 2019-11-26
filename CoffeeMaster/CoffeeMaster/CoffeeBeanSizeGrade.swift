//
//  CoffeeBeanSizeGrade.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

enum CoffeeBeanSizeGrade: String {
    case Peaberries
    case AB_Grade
    case AA_Grade
    case Pulped_natural_process
    case Fully_washed
    
    case Natural_process
    static let Dry_process = CoffeeBeanSizeGrade.Natural_process
    
    case Pacamara
    static let Maragogype = CoffeeBeanSizeGrade.Pacamara
    
    var localizableString : String {
        switch self {
        case .Peaberries: return "Peaberries"
        case .AB_Grade: return "AB_Grade"
        case .AA_Grade: return "AA_Grade"
        case .Pulped_natural_process: return "Pulped_natural_process"
        case .Fully_washed: return "Fully_washed"
        case .Natural_process: return "Natural_process"
        case .Pacamara: return "Pacamara"
        }
    }
    
    var description : String {
        switch self {
        case .Peaberries: return "The result of only one seed forming inside the coffee fruit"
        case .AB_Grade: return "Consider good quality based on size, but of less value than AA grade"
        case .AA_Grade: return "The largest and most valuable beans from a particular lot of coffee"
        case .Pulped_natural_process: return "A little fruit flesh is still stuck to beans, giving a slight orange color"
        case .Fully_washed: return "These fully washed beans appear cleaner than the other two processes"
        case .Natural_process: return "Tipically a very orange/brown color compared with other green coffee due to the processing"
        case .Pacamara: return "Unusually large in size and often considered desirable as a result"
        }
    }
    
    static let allValues: [CoffeeBeanSizeGrade] = [Peaberries, AB_Grade, AA_Grade, Pulped_natural_process, Fully_washed, Natural_process, Pacamara]
}
