//
//  CoffeeVariationCell.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct CoffeeVariationCell: View {
    
    var coffeineEntry: CaffeineEntry
    var variation: CaffeineEntry.Variation
    
    init(_ coffeineEntry: CaffeineEntry, variation: CaffeineEntry.Variation) {
        self.coffeineEntry = coffeineEntry
        self.variation = variation
    }
    
    func getUnit() -> String {
        switch self.coffeineEntry.category {
        case .Coffee:
            return "ml".localized()
        case .Espresso:
            return "shots"
        default:
            return "g".localized()
        }
    }
    
    var body: some View {
        return VStack {
            Text(LocalizedStringKey(coffeineEntry.name)).bold()
            Text("\(Int(variation.volume.getVolumeInML())) \(self.getUnit())")
            Text("\(Int(variation.caffeineAmount.getMilligram()))mg")
        }
    }
}

struct CoffeeVariationCell_Previews: PreviewProvider {
    static let sample_coffeine_entry = StaticDataService.caffeineEntries[0]
    static let sample_coffeine_entry_variation = StaticDataService.caffeineEntries[0].variation[0]

    static var previews: some View {
        CoffeeVariationCell(sample_coffeine_entry, variation: sample_coffeine_entry_variation).modifier(EnvironmemtServices())
    }
}
