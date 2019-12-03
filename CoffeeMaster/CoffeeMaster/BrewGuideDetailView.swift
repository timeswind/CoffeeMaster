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
    @State var isBrewing = false
    
    init(brewGuide: BrewGuide) {
        self.brewGuide = brewGuide
    }
    
    func toggleBrew() {
        isBrewing = !isBrewing
    }
    
    var body: some View {
        return ZStack {
            if (isBrewing) {
                BrewGuideTimerInstructionView().transition(.scale)
            } else {
                BrewGuideWalkThroughView(brewGuide: brewGuide).transition(.scale)
            }
            // control panel with buttons
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.toggleBrew()
                        }
                    }, label: {
                        Text(">")
                        .font(.system(.largeTitle))
                        .frame(width: 77, height: 70)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                    })
                    .background(Color(UIColor.Theme.Accent))
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                    Spacer()
                }
            }
        }.navigationBarTitle(isBrewing ? "" : LocalizedStringKey(self.brewGuide.guideName))
    }
}

#if DEBUG
struct BrewGuideDetailView_Previews : PreviewProvider {
  static var previews: some View {
//    let guide = dependencies.defaultBrewingGuides.guides[0]
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    let store = Store<AppState, AppAction>(initialState: AppState(settings: SettingsState(),brewViewState: BrewViewState(), connectViewState: ConnectViewState(), recordViewState: RecordViewState()), appReducer: appReducer)
    
    return Text("no Preview")
    }
}
#endif

struct BrewGuideWalkThroughView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var brewGuide: BrewGuide!

    var body: some View {
        let weightUnit = store.state.settings.weightUnit.rawValue
        let temperatureUnit = store.state.settings.temperatureUnit.rawValue
        
        let waterVolumn = self.brewGuide.getBrewStepBoilWater()?.getWaterVolumn() ?? 0.0
        let waterTemperature = self.brewGuide.getBrewStepBoilWater()?.getWaterTemperature().getTemperature() ?? 0.0
        
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
                        Text(String(format: "%.0f ml \n %.0f\(temperatureUnit)", waterVolumn, waterTemperature)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
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
        }
    }
}
