//
//  BrewStepScrollDisplayView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/5/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewStepScrollDisplayView: View {
    var brewSteps: [BrewStep]
    @Binding var currentInstructionIndex: Int
    @State var i_index: Int = 0
    
    @State var scrollViewOffset: CGFloat = 0
    @State private var offset: CGPoint = .zero
    @State private var paddingBottom: CGFloat = .zero
    
    init(brewSteps: [BrewStep], currentInstructionIndex: Binding<Int>) {
        self.brewSteps = brewSteps
        self._currentInstructionIndex = currentInstructionIndex
        self.i_index = currentInstructionIndex.wrappedValue
    }
    
    func updateCurrentInstructionIndex(_ index:Int) {
        self.i_index = index
        self.currentInstructionIndex = index
    }
    
    func prevInstruction() {
        if (self.i_index != 0) {
            self.updateCurrentInstructionIndex(self.i_index - 1)
        }
    }
    
    func nextInstruction() {
        if (self.i_index != brewSteps.count - 1) {
            self.updateCurrentInstructionIndex(self.i_index + 1)
        }
    }
    
    var body: some View {
        return HStack{
            Button(action: {
                withAnimation {
                    self.prevInstruction()
                }
            }) {
                Text("prev")
            }
            Spacer()

            ForEach(0..<self.brewSteps.count, id:\.self) { index in
                Group {
                    if (index == self.i_index) {
                        Text(self.brewSteps[self.i_index].instruction)
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
        let sample_brew_steps = dependencies.defaultBrewingGuides.sampleBrewSteps
        return BrewStepScrollDisplayView(brewSteps: sample_brew_steps, currentInstructionIndex: $currentInstructionIndex).previewLayout(.sizeThatFits)
    }
}
