//
//  BrewStepConfigureWaterRow.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewStepConfigureWaterRow: View {
    var brewStepBoildWater: BrewStepBoilWater
    
    init(_ brewStepBoildWater: BrewStepBoilWater) {
        self.brewStepBoildWater = brewStepBoildWater
    }
    
    var body: some View {
        
        return HStack {
            Image("icons-teapot-500").resizable()
                .aspectRatio(contentMode: .fit).frame(width: 44).padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                Text(String(format: "Boil %@ of water".localized(), "\(Int(self.brewStepBoildWater.getWaterVolumn()))\("ml".localized())")).fontWeight(.bold)
                Text("\("WaterTemperature".localized()): \(Int(self.brewStepBoildWater.getWaterTemperature().getTemperature()))\(getTemperatureUnit().rawValue.localized())")
            }.padding()
            
            Spacer()
        }
    }
}

struct BrewStepConfigureWaterRow_Previews: PreviewProvider {
    static let sample_brew_guide_step_boil_water = StaticDataService.defaultBrewGuides.first!.getBrewStepBoilWater()!
    
    static var previews: some View {
        BrewStepConfigureWaterRow(sample_brew_guide_step_boil_water).previewLayout(.sizeThatFits)
    }
}
