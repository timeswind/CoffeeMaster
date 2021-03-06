//
//  PostCardView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import URLImage

struct PostCardView: View {
    var post: Post!
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        let hasImage = post.images_url != nil && post.images_url!.count > 0
        let author_name = post.author_name ?? post.created_by_uid
        return VStack {
            if (hasImage) {
                URLImage(URL(string: self.post.images_url![0])!, placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                // The download has started. CircleProgressView displays the progress.
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                // The download has not yet started. CircleActivityView is animated activity indicator that suits this case.
                                CircleActivityView().stroke(lineWidth: 50.0)
                            }
                        }
                    }
                    .frame(width: 50.0, height: 50.0)
                }, content: {
                    $0.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                
            }
            
            HStack {
                VStack(alignment: .leading) {
                    //                    Text("Tag")
                    //                        .font(.headline)
                    //                        .foregroundColor(.secondary)
                    Text(post.title ?? "")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(Color(UIColor.Theme.Accent))
                        .lineLimit(3)
                    Text("\("WrittenBy".localized()) \(author_name ?? "")".uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                
                Spacer()
            }
            .padding()
            HStack {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Image("icons-chat-room-96")
                    Text("\(post.commont_count ?? 0)").font(.body).fontWeight(.bold)
                    Spacer()
                    
                }.padding()
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Image("icons-espresso-cup-96").accentColor(Color.Theme.Accent)
                    Text("\(post.likes ?? 0)").font(.body).fontWeight(.bold)
                    Spacer()
                }.padding()
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1),
                radius: 5,
                x: 3,
                y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        
    }
}
