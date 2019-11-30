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
    @EnvironmentObject var store: Store<AppState, AppAction>

    var post: Post!
    @State var newComment:String = ""
    
    func fetchComments() {
        if let postid = self.post.id {
            let fetchCommentAction: ConnectViewAsyncAction = .getComments(id: postid)
            store.send(fetchCommentAction)
        }
    }
    
    func postComment() {
        var comment = Comment(body: self.newComment, created_by_uid: store.state.settings.uid!)
        let newCommentAction: ConnectViewAsyncAction = .postComment(comment: comment)
        store.send(newCommentAction)
    }
    
    var body: some View {
        let hasImage = post.images_url != nil && post.images_url!.count > 0
        let author_name = post.author_name ?? post.created_by_uid
        
        let comments = post.comments

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
                MultilineTextField(LocalizedStringKey("NewCommentBody"), text: $newComment, onCommit: {
                    self.postComment()
                })
                
                if (comments.count > 0) {
                    PostCommentsListView(comments: comments)
                }
            }.padding(.init(top: 100, leading: 16, bottom: 0, trailing: 16))
        }.edgesIgnoringSafeArea(.top).onAppear {
            self.fetchComments()
        }
    }
}

struct PostCommentsListView: View {
    @State var comments: [Comment] = []
    
    var body: some View {
        return VStack {
            ForEach(self.comments, id: \.id) { comment in
                Text(comment.body)
            }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
        }

    }
}

