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
    @State var my_comments: [Comment] = []
    var post: Post!
    @State var newComment:String = ""
    
    func fetchComments() {
        if let postid = self.post.id {
            let fetchCommentAction: ConnectViewAsyncAction = .getComments(id: postid)
            store.send(fetchCommentAction)
        }
    }
    
    func postComment() {
        if let postid = self.post.id {
            var comment = Comment(body: self.newComment, created_by_uid: store.state.settings.uid!)
            comment.post_id = postid
            let newCommentAction: ConnectViewAsyncAction = .postComment(comment: comment)
            store.send(newCommentAction)
        }
    }
    
    func voidCall() {
        
    }
    
    var body: some View {
        let hasImage = post.images_url != nil && post.images_url!.count > 0
        let author_name = post.author_name ?? post.created_by_uid
        
        let comments = Binding<[Comment]>(
            get: {
                return self.store.state.connectViewState.comments[self.post.id!] ?? []
        },
            set: {
                self.my_comments = $0
        }
        )
        
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                if (hasImage) {
                    URLImage(URL(string: post.images_url![0])!, placeholder: {
                        ProgressView($0) { progress in
                            ZStack {
                                if progress > 0.0 {
                                    CircleProgressView(progress).stroke(lineWidth: 8.0)
                                }
                                else {
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
                MultilineTextField(LocalizedStringKey("NewCommentBody"), text: $newComment)
                Button(LocalizedStringKey("PostComment")) {
                    self.postComment()
                }
                PostCommentsListView(comments: comments)
            }.padding(.init(top: 100, leading: 16, bottom: 0, trailing: 16))
        }.edgesIgnoringSafeArea(.top).onAppear {
            self.fetchComments()
        }
    }
}

struct PostCommentsListView: View {
    @Binding var comments: [Comment]
    
    var body: some View {
        return VStack(alignment: .leading) {
            ForEach(self.comments, id: \.id) { comment in
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        URLImage(URL(string: "https://via.placeholder.com/100")!, content: {
                            $0.image.resizable()
                                .scaledToFill()
                                .border(Color(white: 0.75))
                        }).frame(width: 40, height: 40).clipShape(Circle())
                        Text(comment.author_name ?? "User").foregroundColor(.gray).font(.callout)
                        Spacer()
                    }
                    Text(comment.body).font(.body).padding(.top)
                    
                    HStack {
                        Spacer()
                        Text(Utilities.convertTimestamp(date: comment.created_at!.dateValue())).font(.footnote).foregroundColor(.gray)
                    }

                }.padding(.all).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                )
            }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        
    }
}

