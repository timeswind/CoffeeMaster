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
            VStack(alignment: .leading) {
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
                        
                        Text(post.body)
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .layoutPriority(100)
                    
                    Spacer()
                }
                
                Text(LocalizedStringKey("Comments")).font(.title).fontWeight(.bold).padding(.top)
            }.padding(.init(top: 100, leading: 16, bottom: 0, trailing: 16))
        }.edgesIgnoringSafeArea(.top)
    }
}
