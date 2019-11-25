//
//  BrewGuideDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/19/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

public struct AccentCircleTextViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.frame(width: 100, height: 100, alignment: .center).background(Color(UIColor.Theme.Accent)).clipShape(Circle()).foregroundColor(.white)
    }
}

struct BrewGuideDetailView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>

    var brewGuide: BrewGuide!
    
    init(brewGuide: BrewGuide) {
        self.brewGuide = brewGuide
    }
    
    var body: some View {
        let weightUnit = store.state.settings.weightUnit.rawValue
        let grindSize: String = self.brewGuide.getBrewStepGrindCoffee()!.grindSize.localizableString
        let brewSteps = self.brewGuide.getBrewSteps()
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    VStack {
                        Image("\(brewGuide.baseBrewMethod.baseBrewMethodType.rawValue)-icon").resizable().scaledToFit().frame(width: 106.0, height: 106.0)
                            .aspectRatio(CGSize(width:100, height: 100), contentMode: .fit)
                        Text(self.brewGuide.guideDescription).padding(.all, 18)
                    }

                    Spacer()
                }

                
                HStack {
                    Spacer()
                    VStack {
                        Text(LocalizedStringKey(grindSize)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("GrindSize")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }
                    VStack {
                        Text(String(format: "%.0f \(weightUnit)", self.brewGuide.getBrewStepGrindCoffee()?.getCoffeeAmount().getWeight() ?? 0)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("GroundCoffee")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }
                    VStack {
                        Text(String(format: "%.0f ml", self.brewGuide.getBrewStepBoilWater()?.getWaterAmount().getWeight() ?? 0)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("Water")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }
                    Spacer()
                }
                
                Text(LocalizedStringKey("Steps")).font(.headline).fontWeight(.black).padding([.leading, .top], 36)
                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(0..<brewSteps.count, id: \.self) { index in
                    //                     Text(brewSteps[index].brewType!.rawValue)
                                         Text(brewSteps[index].instruction)
                                     }
                }.padding(.horizontal, 36)


                Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }.navigationBarTitle(LocalizedStringKey(self.brewGuide.guideName))
    }
}
