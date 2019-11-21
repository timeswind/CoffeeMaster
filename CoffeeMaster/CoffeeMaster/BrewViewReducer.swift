//
//  BrewViewReducer.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

enum BrewViewAction {
    case setMyBrewGuides(guides: [BrewGuide])
}

struct BrewViewReducer {
    let reducer: Reducer<BrewViewState,  BrewViewAction> = Reducer { state, action in
        switch action {
        case let .setMyBrewGuides(guides):
            state.myBrewGuides = guides
        }
    }
}

//enum BrewViewAsyncAction: Effect {
//    case getAllPosts(query: String)
//    case newPost(post: Post)
//
//    func mapToAction() -> AnyPublisher<AppAction, Never> {
//        switch self {
//        case let .getAllPosts(query):
//            return dependencies.webDatabaseQueryService
//                .getAllPosts(query: query)
//            .replaceError(with: [])
//                .map { let connectViewAction: ConnectViewAction = .setPosts(posts: $0)
//                    return AppAction.connectview(action: connectViewAction) }
//            .eraseToAnyPublisher()
//        case let .newPost(post):
//            return dependencies.webDatabaseQueryService
//            .newPost(post: post)
//                .replaceError(with: nil)
//                .map {
//                    if ($0 != nil) {
//                        let connectViewAction: ConnectViewAction = .newPostAdded(post: $0!)
//                        return AppAction.connectview(action: connectViewAction)
//                    } else {
//                        return AppAction.emptyAction(action: .nilAction(nil: true))
//                    }
//            }
//            .eraseToAnyPublisher()
//        }
//    }
//}


let brewViewReducer = BrewViewReducer()
