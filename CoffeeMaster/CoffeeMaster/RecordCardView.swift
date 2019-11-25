//
//  RecordCardView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct RecordCardView: View {
    var record: Record!
    
    init(record: Record) {
        self.record = record
    }
    
    var body: some View {
               VStack {
//                   Image("swiftui-button")
//                       .resizable()
//                       .aspectRatio(contentMode: .fit)
        
                   HStack {
                       VStack(alignment: .leading) {

                        Text(record.title)
                               .font(.title)
                               .fontWeight(.black)
                            .foregroundColor(Color(UIColor.Theme.Accent))
                               .lineLimit(3)
                        Text("Created at by \(record.created_by_uid)")
                               .font(.caption)
                               .foregroundColor(.secondary)
                       }
                       .layoutPriority(100)
        
                       Spacer()
                   }
                   .padding()
               }
               .cornerRadius(10)
               .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
               )
               .padding([.top])
    }
}
