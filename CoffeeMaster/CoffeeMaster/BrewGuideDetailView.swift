//
//  BrewGuideDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/19/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

extension View {
    func animate(animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}


public struct AccentCircleTextViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.frame(width: 100, height: 100, alignment: .center).background(Color(UIColor.Theme.Accent)).clipShape(Circle()).foregroundColor(.white)
    }
}

struct BrewGuideDetailView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @ObservedObject var stopWatch = StopWatch()
    
    var brewGuide: BrewGuide!
    
    @State var isBrewing = false
    @State var isInstructionWalkThrough = true
    @State var currentInstructionIndex = 0
    
    init(brewGuide: BrewGuide) {
        self.brewGuide = brewGuide
    }
    
    func start() {
        print("Start")
        isBrewing = true
        self.stopWatch.start()
    }
    
    func pause() {
        isBrewing = false
        self.stopWatch.pause()
    }
    
    func resetTimer() {
        self.stopWatch.reset()
    }
    
    func toggleBrew() {
        if (isBrewing) {
            self.pause()
        } else {
            let maxTimeAllowedInSec = self.brewGuide.getMaxiumBrewTimeInSec()
            self.stopWatch.setMaxTimeInSec(maxTimeInSec: maxTimeAllowedInSec)
            self.currentInstructionIndex = 0
            isInstructionWalkThrough = false
            self.start()
        }
    }
    
    func exitBrew() {
        self.pause()
        self.resetTimer()
        isBrewing = false
        isInstructionWalkThrough = true
    }
    
    func updateTimerTime(_ timeInSec: Int) {
        self.stopWatch.setTimeInSet(timeInSet: timeInSec)
    }
    
    var body: some View {
        
        let mainControlIcon = (isInstructionWalkThrough || (!isInstructionWalkThrough && !isBrewing)) ? "play" : "pause"
        let title = isInstructionWalkThrough ? LocalizedStringKey(self.brewGuide.guideName) : ""
        
        let timerTime = Binding<String>(get: { () -> String in
            return self.stopWatch.stopWatchTime
        }) { (_) in
            return
        }
        
        let progressPercent = Binding<CGFloat>(get: { () -> CGFloat in
            return self.stopWatch.progressPercent
        }) { (_) in
            return
        }
        
        return ZStack {
            if (isInstructionWalkThrough) {
                BrewGuideWalkThroughView(brewGuide: brewGuide)
                    .transition(.scale)
            } else {
                VStack {
                    BrewGuideTimerInstructionView(stopWatchTime: timerTime, brewPercent: progressPercent)
                    BrewStepScrollDisplayView(brewGuide: self.brewGuide, currentInstructionIndex: $currentInstructionIndex, onUpdateTime: { timeInSec in
                        self.updateTimerTime(timeInSec)
                    })
                    Spacer()
                }
                .transition(.scale)
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
                        
                        FAText(iconName: mainControlIcon, size: 24, style: .solid)
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.white)
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
        }.navigationBarTitle(title).navigationBarItems(
            trailing:
            Button(action: {
                withAnimation {
                    self.exitBrew()
                }
                
            }) {
                Text(isInstructionWalkThrough ? "" :LocalizedStringKey("ExitBrew"))
        })
    }
}

struct BrewGuideWalkThroughView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var brewGuide: BrewGuide!
    @State var scale: CGFloat = 0.5
    @State var opacity: Double = 0
    @State var offset: CGSize = CGSize(width: 100, height: 0)
    
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
                            .scaleEffect(self.scale)
                            .animate(animation: Animation.spring(dampingFraction: 0.5)) {
                                self.scale = 1
                        }
                        Text(self.brewGuide.guideDescription).padding(.all, 18)
                    }
                    
                    Spacer()
                }
                
                
                HStack {
                    Spacer()
                    VStack {
                        Text(LocalizedStringKey(grindSize)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("GrindSize")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }.scaleEffect(self.scale)
                    VStack {
                        Text(String(format: "%.0f \(weightUnit)", self.brewGuide.getBrewStepGrindCoffee()?.getCoffeeAmount().getWeight() ?? 0)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("GroundCoffee")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }.scaleEffect(self.scale)
                    VStack {
                        Text(String(format: "%.0f ml \n %.0f\(temperatureUnit)", waterVolumn, waterTemperature)).fontWeight(.bold).modifier(AccentCircleTextViewModifier())
                        Text(LocalizedStringKey("Water")).font(.caption).fontWeight(.bold).padding(.top, 8)
                    }.scaleEffect(self.scale)
                    Spacer()
                }
                
                
                HStack(alignment: .bottom, spacing: 0) {
                    FAText(iconName: "list", size: 20, style: .solid).padding([.leading,], 36).padding(.trailing, 8)
                    
                    Text(LocalizedStringKey("Steps")).font(.headline).fontWeight(.black).padding([.top], 36)
                    
                    
                    Spacer()
                }.padding(.bottom, 8).foregroundColor(Color.Theme.Accent)
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<brewSteps.count, id: \.self) { index in
                        GeometryReader { geometry in
                            
                            Text(brewSteps[index].instruction)
                                .opacity(self.opacity)
                                .offset(self.offset)
                                .animation(Animation.easeInOut(duration: 0.5).delay(Double(index) * 0.1))
                                .animate() {
                                    self.offset = CGSize.zero
                                    
                                    self.opacity = 1
                            }
                        }
                    }
                }.padding(.horizontal, 36)
                
                
                Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct BrewGuideDetailView_Previews: PreviewProvider {
    static var sample_brew_guide = StaticDataService.defaultBrewGuides.first!
    
    static var previews: some View {
        BrewGuideDetailView(brewGuide: sample_brew_guide).modifier(EnvironmemtServices())
    }
}
