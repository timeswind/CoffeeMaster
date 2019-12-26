//
//  WidgetView.swift
//  Coffee Master Widget
//
//  Created by Mingtian Yang on 12/3/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    var onOpenURL: ((String) -> Void)?
    
    func openURL(urlString: String) {
        if let onOpenURL = self.onOpenURL {
            onOpenURL(urlString)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {self.openURL(urlString: "coffeemaster://brew")}) {
                HStack {
                    Image("HarioV60-icon").resizable()
                    .aspectRatio(contentMode: .fit).frame(height: 22)
                    
                    Text("Brew Coffee").font(.caption).foregroundColor(Color.white).fontWeight(.bold)
                    }.padding(8).background(Color.Theme.Accent)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                )
                
            }.buttonStyle(PlainButtonStyle())
            
            HStack {
                Button(action: {self.openURL(urlString: "coffeemaster://record.note")}) {
                    HStack {
                        
                        Image("record-icon-select-100").resizable()
                        .aspectRatio(contentMode: .fit).frame(width: 22).foregroundColor(Color.white)
                        Text("Record Note").font(.caption).foregroundColor(Color.white).fontWeight(.bold)
                        }.padding(8).background(Color.Theme.Accent)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                    )
                }.padding(.vertical, 4)
                Button(action: {self.openURL(urlString: "coffeemaster://record.caffeine")}) {
                    HStack {
                        Image("icons-coffee-beans-500").resizable()
                        .aspectRatio(contentMode: .fit).frame(height: 22)
                        
                        Text("Record Caffeine").font(.caption).foregroundColor(Color.white).fontWeight(.bold)
                        }.padding(8).background(Color.Theme.Accent)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                    )
                }.buttonStyle(PlainButtonStyle())
            }

        }.padding().background(Color.clear)
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView().previewLayout(.sizeThatFits)
    }
}
