//
//  BrewGuideTimerInstructionView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/2/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewGuideTimerInstructionView: View {
    @Binding var stopWatchTime: String
        
    var body: some View {
        return ZStack {
            VStack {
                Text(self.stopWatchTime).font(.system(size: 70, weight: .bold, design: .monospaced))
                .frame(width: UIScreen.main.bounds.size.width,
                       height: 300,
                       alignment: .center)
                
                Spacer()
            }
        }
    }
}

struct BrewGuideTimerInstructionView_Previews : PreviewProvider {
    static var previews: some View {
        let timerTime = Binding<String>(get: { () -> String in
            return "00:00:00"
        }) { (_) in
            return
        }
        return BrewGuideTimerInstructionView(stopWatchTime: timerTime)
    }
}
