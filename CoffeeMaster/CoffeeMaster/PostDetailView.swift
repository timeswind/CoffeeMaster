//
//  PostDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import URLImage

struct PostDetailView: View {
    var post: Post!
    
    var body: some View {
        let hasImage = post.images_url != nil && post.images_url!.count > 0
        let author_name = post.author_name ?? post.created_by_uid

        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
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
                        Text("Written by \(author_name)".uppercased())
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
