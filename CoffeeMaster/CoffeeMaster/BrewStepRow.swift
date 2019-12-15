//
//  BrewStepRow.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewStepRow: View {
    var brewStep: BrewStep
    var imageKey: String
    var instruction: String
    var duration: String
    
    init(_ brewStep: BrewStep) {
        self.brewStep = brewStep
        
        if (brewStep.instruction.isEmpty) {
            self.instruction = brewStep.brewType.rawValue.localized()
        } else {
            self.instruction = brewStep.instruction
        }
        self.duration = "\("Duration".localized()): \(brewStep.duration)\("secUnit".localized())"

        switch brewStep.brewType {
        case .Bloom:
            self.imageKey = "icons-teapot-500"
        case .Stir:
            self.imageKey = "icons-sticks-500"

        case .Wait:
            self.imageKey = "icons-clock-500"
        case .Other:
            self.imageKey = "icons-coffee-beans-500"
        default:
            self.imageKey = "icons-coffee-beans-500"
        }
    }
    
    var body: some View {
        HStack {
            Image(imageKey).resizable()
                .aspectRatio(contentMode: .fit).frame(width: 44).padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                Text(instruction).fontWeight(.bold)
                Text(duration)
            }.padding()
            
            Spacer()
        }
    }
}

struct BrewStepRow_Previews: PreviewProvider {
    static let sample_brew_guide_bloom = StaticDataService.defaultBrewGuides[1].getBrewSteps()[0]
    static let sample_brew_guide_stir = StaticDataService.defaultBrewGuides[1].getBrewSteps()[1]
    static let sample_brew_guide_other = StaticDataService.defaultBrewGuides[1].getBrewSteps()[2]
    static let sample_brew_guide_wait = StaticDataService.defaultBrewGuides[1].getBrewSteps()[5]

    
    static var previews: some View {
        Group {
            BrewStepRow(sample_brew_guide_bloom).previewLayout(.sizeThatFits)
            BrewStepRow(sample_brew_guide_stir).previewLayout(.sizeThatFits)
            BrewStepRow(sample_brew_guide_other).previewLayout(.sizeThatFits)
            BrewStepRow(sample_brew_guide_wait).previewLayout(.sizeThatFits)
        }
    }
}
