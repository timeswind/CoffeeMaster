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
        return VStack {
            if (hasImage) {
                URLImage(URL(string: post.images_url![0])!, placeholder: {
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
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
            .padding([.top])
    }
}
