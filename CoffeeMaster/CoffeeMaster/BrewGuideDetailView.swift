//
//  BrewGuideDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/19/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewGuideDetailView: View {
    var brewGuide: BrewGuide!
    
    init(brewGuide: BrewGuide) {
        self.brewGuide = brewGuide
    }
    
    var body: some View {
        let grindSize: String = self.brewGuide.getBrewStepGrindCoffee()!.grindSize.localizableString
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                Text(self.brewGuide.guideName)
                Text(self.brewGuide.guideDescription)
                Text(LocalizedStringKey(grindSize))
                Text(String(format: "%.2f", self.brewGuide.getBrewStepGrindCoffee()?.getCoffeeAmount() ?? 0))
                Text(String(format: "%.2f", self.brewGuide.getBrewStepBoilWater()?.getWaterAmount() ?? 0))

                Spacer()
            }
        }
    }
}
