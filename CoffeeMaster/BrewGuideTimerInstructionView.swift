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
    @Binding var brewPercent: CGFloat
    
    var body: some View {
        return ZStack {
            VStack {
                Indicator(pct: self.brewPercent, time: self.stopWatchTime)
                    .frame(width: 320,
                           height: 320,
                           alignment: .center)
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
        
        let brewPercent = Binding<CGFloat>(get: { () -> CGFloat in
            return CGFloat(0.519)
        }) { (_) in
            return
        }
        return BrewGuideTimerInstructionView(stopWatchTime: timerTime, brewPercent: brewPercent).previewLayout(.sizeThatFits)
    }
}

struct Indicator: View {
    var pct: CGFloat
    var time: String
    
    var body: some View {
        return Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(netHex: 0xde6b35), Color(netHex: 0xf9b282)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 300, height: 300)
            .modifier(PercentageIndicator(pct: self.pct, time: self.time))
    }
}

struct PercentageIndicator: AnimatableModifier {
    var pct: CGFloat = 0
    var time: String = "00:00:00"
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(ArcShape(pct: pct).foregroundColor(Color.Theme.Accent))
            .overlay(LabelView(pct: pct, time: time))
    }
    
    struct ArcShape: Shape {
        let pct: CGFloat
        
        func path(in rect: CGRect) -> Path {
            
            var p = Path()
            
            p.addArc(center: CGPoint(x: rect.width / 2.0, y:rect.height / 2.0),
                     radius: rect.height / 2.0 + 5.0,
                     startAngle: .degrees(0),
                     endAngle: .degrees(360.0 * Double(pct)), clockwise: false)
            
            return p.strokedPath(.init(lineWidth: 10))
        }
    }
    
    struct LabelView: View {
        let pct: CGFloat
        var time: String
        
        var body: some View {
            VStack {
                Text("\(Int(pct * 100)) %")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(time)
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
            
        }
    }
}
