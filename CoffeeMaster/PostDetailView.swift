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
    @EnvironmentObject var keyboard: KeyboardResponder
    
    var post: Post!
    
    @State var my_comments: [Comment] = []
    @State var newComment:String = ""
    @State var liked: Bool = false
    @State var editPost: Post = .Default
    
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
            self.newComment = ""
            self.updatePostCommentCount()
            UIApplication.shared.endEditing()
        }
    }
    
    func viewDidAppear() {
        self.editPost = self.post
        self.fetchComments()
    }
    
    func likePost() {
        
        var updatedPost = self.post!
        if (updatedPost.likes == nil) {
            updatedPost.likes = 1
            self.editPost.likes = 1
        } else {
            updatedPost.likes = updatedPost.likes! + 1
            self.editPost.likes = updatedPost.likes
        }
        self.liked = true
        store.send(ConnectViewAsyncAction.updatePost(post: updatedPost))
        
    }
    
    func updatePostCommentCount() {
        var updatedPost = self.post!
        if (updatedPost.commont_count == nil) {
            updatedPost.commont_count = 1
        } else {
            updatedPost.commont_count = updatedPost.commont_count! + 1
        }
        store.send(ConnectViewAsyncAction.updatePost(post: updatedPost))
    }
    
    var body: some View {
        let hasImage = post.images_url != nil && post.images_url!.count > 0
        let hasLocation = post.location != nil
        let hasBrewGuide = post.brewGuide != nil
        let author_name = post.author_name ?? post.created_by_uid ?? "Author name"
        let allowComment = post.allow_comment ?? true
        
        let comments = Binding<[Comment]>(
            get: {
                return self.store.state.connectViewState.comments[self.post.id!] ?? []
        },
            set: {
                self.my_comments = $0
        }
        )
        
        
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 10) {
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
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Tag")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
                        Text(post.title ?? "")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color(UIColor.Theme.Accent))
                            .lineLimit(3)
                        Text("\("WrittenBy".localized()) \(author_name)".uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(post.body ?? "")
                            .padding(.vertical)
                            .font(.body)
                            .foregroundColor(.black)
                        
                        if (hasLocation) {
                            LocationCardView(location: post.location!).frame(height: 200)
                        }
                        
                        if (hasBrewGuide) {
                            NavigationLink(destination: BrewGuideDetailView(brewGuide: post.brewGuide!)) {
                                BrewGuideCardView(brewGuide: post.brewGuide!)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        
                        if (post.images_url?.count != nil) {
                            
                            ForEach(0..<post.images_url!.count, id:\.self) { index in
                                URLImage(URL(string: self.post.images_url![index])!, placeholder: {
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

                        }
                    }
                }
                
                if (allowComment) {
                    Text(LocalizedStringKey("Comments")).font(.title).fontWeight(.bold).padding(.top, 10)
                    TextField(LocalizedStringKey("NewCommentBody"), text: $newComment).padding(.bottom)
                    
                    if (!self.newComment.isEmpty) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.postComment()
                            }) {
                                HStack {
                                    Text(LocalizedStringKey("PostComment"))
                                        .fontWeight(.bold)
                                        .font(.body)
                                        .padding(.all, 8)
                                        .background(Color(UIColor.Theme.Accent))
                                        .cornerRadius(5)
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.bottom)
                    }
                    PostCommentsListView(comments: comments)
                } else {
                    Text(LocalizedStringKey("CommentDisabled")).font(.title).fontWeight(.bold).padding(.top, 10)

                }
                

            }.padding(.init(top: 100, leading: 16, bottom: 0, trailing: 16))
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
            .padding(.bottom, keyboard.currentHeight).navigationBarItems(
            trailing:
            Button(action: {self.likePost()}) {
                HStack {
                    Image(self.liked ? "espresso-cup-fill" :"espresso-cup-outline")
                    Text("\(self.editPost.likes ?? 0)").fontWeight(.bold)
                }
        })
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                self.viewDidAppear()
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
                    }.padding(.top)
                    
                }.padding(.all).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                )
            }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        
    }
}

