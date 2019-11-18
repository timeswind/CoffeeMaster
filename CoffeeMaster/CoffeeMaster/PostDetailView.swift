//
//  PostDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    var post: Post!
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                //                   Image("swiftui-button")
                //                       .resizable()
                //                       .aspectRatio(contentMode: .fit)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tag")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(post.title)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color(UIColor.Theme.Accent))
                            .lineLimit(3)
                        Text("Written by \(post.created_by_uid)".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(100)
                    
                    Spacer()
                }
                .padding()
            }.padding(.init(top: 100, leading: 0, bottom: 0, trailing: 0))
        }.edgesIgnoringSafeArea(.top)
    }
}
