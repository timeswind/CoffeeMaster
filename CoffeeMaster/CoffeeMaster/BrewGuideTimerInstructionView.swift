//
//  BrewGuideTimerInstructionView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/2/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewGuideTimerInstructionView: View {
    @ObservedObject var stopWatch = StopWatch()
    
    func start() {
        self.stopWatch.start()
    }
        
    var body: some View {
        return ZStack {
            VStack {
                Text(self.stopWatch.stopWatchTime)
                .font(.system(size: 70))
                .frame(width: UIScreen.main.bounds.size.width,
                       height: 300,
                       alignment: .center)
                
                Spacer()
            }
        }.onAppear {
            self.start()
        }
    }
}

struct BrewGuideTimerInstructionView_Previews : PreviewProvider {
    static var previews: some View {
        BrewGuideTimerInstructionView()
    }
}
