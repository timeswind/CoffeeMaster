//
//  BrewGuideCardView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewGuideCardView: View {
    var brewGuide: BrewGuide
    
    var body: some View {
    
        return VStack(alignment: .leading, spacing: 0) {
            Text("BrewGuide").font(.headline).fontWeight(.bold).padding(.bottom, 4)
            HStack {
                    VStack {
                        Image("\(brewGuide.baseBrewMethod.baseBrewMethodType.rawValue)-icon").resizable().scaledToFit().frame(width: 106.0, height: 106.0)
                            .aspectRatio(CGSize(width:100, height: 100), contentMode: .fit)
                           
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(brewGuide.guideName).font(.title).fontWeight(.bold)
                        Text(brewGuide.guideDescription).font(.body).fontWeight(.regular)
                        Text("\("TotalBrewTime".localized()): \(brewGuide.getMaxiumBrewTimeInSec())\("secUnit".localized())").font(.footnote).fontWeight(.semibold).foregroundColor(Color.gray).padding(.top, 8)
                    }
                    
                    
                    Spacer()
                }.padding(.vertical)
                .background(Color.white).cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
            )
            }
        }
}

struct BrewGuideCardView_Previews: PreviewProvider {
    static var sample_brew_guide = StaticDataService.defaultBrewGuides.first!

    static var previews: some View {
        BrewGuideCardView(brewGuide: sample_brew_guide).modifier(EnvironmemtServices())
    }
}
