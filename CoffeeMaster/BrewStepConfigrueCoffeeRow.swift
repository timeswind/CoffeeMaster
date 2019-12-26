//
//  BrewStepConfigrueCoffeeRow.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewStepConfigrueCoffeeRow: View {
    var brewStepGrindCoffee: BrewStepGrindCoffee
    
    init(_ brewStepGrindCoffee: BrewStepGrindCoffee) {
        self.brewStepGrindCoffee = brewStepGrindCoffee
    }
    
    var body: some View {
        
        return HStack {
            Image("icons-grinder-500").resizable()
                .aspectRatio(contentMode: .fit).frame(width: 44).padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                Text(String(format: "Grind %@ of coffee".localized(), "\(self.brewStepGrindCoffee.getCoffeeAmount().getWeightWholeNumber())\(getWeightUnit().rawValue.localized())")).fontWeight(.bold)
                Text("\("GrindSize".localized()): \(self.brewStepGrindCoffee.grindSize.rawValue.localized())")
            }.padding()
            
            Spacer()
        }
    }
}

struct BrewStepConfigrueCoffeeRow_Previews: PreviewProvider {
    static let sample_brew_guide_step_grind_coffee = StaticDataService.defaultBrewGuides.first!.getBrewStepGrindCoffee()!
    
    static var previews: some View {
        BrewStepConfigrueCoffeeRow(sample_brew_guide_step_grind_coffee).previewLayout(.sizeThatFits)
    }
}
