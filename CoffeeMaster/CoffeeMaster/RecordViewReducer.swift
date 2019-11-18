//
//  RecordViewActions.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine
import Firebase

enum RecordViewAsyncAction: Effect {
    case repoSearch(query: String)
    case getAllPosts(query: String)
    case newPost(post: Post)
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .repoSearch(query):
            return dependencies.githubService
                .searchPublisher(matching: query)
                .replaceError(with: [])
                .map { let repoAction: ReposAction = .setSearchResults(repos: $0)
                    return AppAction.repos(repos: repoAction) }
                .eraseToAnyPublisher()
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
