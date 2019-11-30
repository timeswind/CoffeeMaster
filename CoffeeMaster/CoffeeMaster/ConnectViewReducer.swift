//
//  ConnectViewReducer.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

enum ConnectViewAction {
    case newPostAdded(post: Post)
    case setPosts(posts: [Post])
    case setCurrentEditingPost(post: Post)
    case setNewPostFormPresentStatus(isPresent: Bool)
    case setComments(forPost: String, comments: [Comment])
    case newComment(comment: Comment)
}

struct ConnectViewReducer {
    let reducer: Reducer<ConnectViewState, ConnectViewAction> = Reducer { state, action in
        switch action {
        case let .setNewPostFormPresentStatus(isPresent):
            state.newPostFormPresented = isPresent
        case let .setPosts(posts):
            state.posts = posts
        case let .setCurrentEditingPost(post):
            state.composing_post = post
        case let .newPostAdded(post):
            state.newPostFormPresented = false
            state.composing_post = nil
            state.posts.insert(post, at: 0)
        case let .setComments(postid, comments):
            for (index, post) in state.posts.enumerated() {
                if (post.id == postid) {
                    state.posts[index].comments = comments
                    break
                }
            }
        case let .newComment(comment):
            for (index, post) in state.posts.enumerated() {
                if (post.id == comment.post_id) {
                    state.posts[index].comments.insert(comment, at: 0)
                    break
                }
            }
        }
    }
}

enum ConnectViewAsyncAction: Effect {
    case getAllPosts(query: String)
    case newPost(post: Post)
    case getComments(id: String)
    case postComment(comment: Comment)
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .getAllPosts(query):
            return dependencies.webDatabaseQueryService
                .getAllPosts(query: query)
                .replaceError(with: [])
                .map { let connectViewAction: ConnectViewAction = .setPosts(posts: $0)
                    return AppAction.connectview(action: connectViewAction) }
                .eraseToAnyPublisher()
        case let .newPost(post):
            return dependencies.webDatabaseQueryService
                .newPost(post: post)
                .replaceError(with: nil)
                .map {
                    if ($0 != nil) {
                        let connectViewAction: ConnectViewAction = .newPostAdded(post: $0!)
                        return AppAction.connectview(action: connectViewAction)
                    } else {
                        return AppAction.emptyAction(action: .nilAction(nil: true))
                    }
            }
            .eraseToAnyPublisher()
        case let .getComments(id):
            return dependencies.webDatabaseQueryService
                .getComments(forPost: id)
                .replaceError(with: [])
                .map {
                    let setCommentsAction: ConnectViewAction = .setComments(forPost: id, comments: $0)
                    return AppAction.connectview(action: setCommentsAction)
                    
            }
            .eraseToAnyPublisher()
            
        case let .postComment(comment):
            return dependencies.webDatabaseQueryService
                .postComment(comment: comment)
                .replaceError(with: nil)
                .map {
                    if ($0 != nil) {
                        let connectViewAction: ConnectViewAction = .newComment(comment: $0!)
                        return AppAction.connectview(action: connectViewAction)
                    } else {
                        return AppAction.emptyAction(action: .nilAction(nil: true))
                    }
            }
            .eraseToAnyPublisher()
        }
    }
}


let connectViewReducer = ConnectViewReducer()
