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
        }
    }
}

enum ConnectViewAsyncAction: Effect {
    case getAllPosts(query: String)
    case newPost(post: Post)
    
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
        }
    }
}


let connectViewReducer = ConnectViewReducer()
