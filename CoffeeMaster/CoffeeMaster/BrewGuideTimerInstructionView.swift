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


//struct ContentView: View {
//    @State private var percent: CGFloat = 0
//
//    var body: some View {
//        VStack {
//            Spacer()
//            Color.clear.overlay(Indicator(pct: self.percent))
//
//            Spacer()
//            HStack(spacing: 10) {
//                MyButton(label: "0%", font: .headline) { withAnimation(.easeInOut(duration: 1.0)) { self.percent = 0 } }
//
//                MyButton(label: "27%", font: .headline) { withAnimation(.easeInOut(duration: 1.0)) { self.percent = 0.27 } }
//
//                MyButton(label: "100%", font: .headline) { withAnimation(.easeInOut(duration: 1.0)) { self.percent = 1.0 } }
//            }
//        }.navigationBarTitle("Example 10")
//    }
//}

struct Indicator: View {
    var pct: CGFloat

    var body: some View {
        return Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 150, height: 150)
            .modifier(PercentageIndicator(pct: self.pct))
    }
}

struct PercentageIndicator: AnimatableModifier {
    var pct: CGFloat = 0

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(ArcShape(pct: pct).foregroundColor(.red))
            .overlay(LabelView(pct: pct))
    }

    struct ArcShape: Shape {
        let pct: CGFloat

        func path(in rect: CGRect) -> Path {

            var p = Path()

            p.addArc(center: CGPoint(x: rect.width / 2.0, y:rect.height / 2.0),
                     radius: rect.height / 2.0 + 5.0,
                     startAngle: .degrees(0),
                     endAngle: .degrees(360.0 * Double(pct)), clockwise: false)

            return p.strokedPath(.init(lineWidth: 10, dash: [6, 3], dashPhase: 10))
        }
    }

    struct LabelView: View {
        let pct: CGFloat

        var body: some View {
            Text("\(Int(pct * 100)) %")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
