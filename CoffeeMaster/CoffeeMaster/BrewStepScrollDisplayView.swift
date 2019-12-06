//
//  BrewStepScrollDisplayView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/5/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewStepScrollDisplayView: View {
    var brewGuide: BrewGuide
    @Binding var currentInstructionIndex: Int
    @State var i_index: Int = 0
    
    @State var scrollViewOffset: CGFloat = 0
    @State private var offset: CGPoint = .zero
    @State private var paddingBottom: CGFloat = .zero
    
    private var onUpdateTime: ((_ timeInSec: Int) -> Void)?
    
    
    init(brewGuide: BrewGuide, currentInstructionIndex: Binding<Int>, onUpdateTime: ((_ timeInSec: Int) -> Void)? = nil) {
        self.brewGuide = brewGuide
        self._currentInstructionIndex = currentInstructionIndex
        self.i_index = currentInstructionIndex.wrappedValue
        self.onUpdateTime = onUpdateTime
    }
    
    func updateCurrentInstructionIndex(_ index:Int) {
        self.i_index = index
        self.currentInstructionIndex = index
        
        let passedTimeInSec = self.brewGuide.getPassedTimeInSecForStep(at: index)
        if let onUpdateTime = self.onUpdateTime {
            onUpdateTime(passedTimeInSec)
        }
    }
    
    func prevInstruction() {
        if (self.i_index != 0) {
            let newIndex = self.i_index - 1
            self.updateCurrentInstructionIndex(newIndex)
        } else {
            // reset time to start time
            if let onUpdateTime = self.onUpdateTime {
                onUpdateTime(0)
            }
        }
    }
    
    func nextInstruction() {
        if (self.i_index != self.brewGuide.getBrewSteps().count - 1) {
            let newIndex = self.i_index + 1
            self.updateCurrentInstructionIndex(newIndex)
        }
    }
    
    var body: some View {
        let brewSteps = brewGuide.getBrewSteps()
        return HStack{
            Button(action: {
                withAnimation {
                    self.prevInstruction()
                }
            }) {
                Text("prev")
            }
            Spacer()

            ForEach(0..<brewSteps.count, id:\.self) { index in
                Group {
                    if (index == self.i_index) {
                        Text(brewSteps[self.i_index].instruction)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            .transition(.scale)
                    } else {
                        EmptyView()
                    }
                }

            }
            



            Spacer()
            Button(action: {
                withAnimation {
                    self.nextInstruction()
                }
            }) {
                Text("next")
            }
            
        }.multilineTextAlignment(.center)
        
        
    }
}



struct BrewStepScrollDisplayView_Previews: PreviewProvider {
    @State static var currentInstructionIndex = 1
    
    static var previews: some View {
        print("parent \(self.currentInstructionIndex)")
        let sample_brew_guide = dependencies.defaultBrewingGuides.getGuides().first!
        return BrewStepScrollDisplayView(brewGuide: sample_brew_guide, currentInstructionIndex: $currentInstructionIndex).previewLayout(.sizeThatFits)
    }
}
