//
//  RecordViewActions.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

enum RecordViewAction {
    case newRecordAdded(record: Record)
    case setRecords(records: [Record])
    case setAddRecordFormPresentStatus(isPresent: Bool)
}

struct RecordViewReducer {
    let reducer: Reducer<RecordViewState, RecordViewAction> = Reducer { state, action in
        switch action {
        case let .setAddRecordFormPresentStatus(isPresent):
            state.addRecordFormPresented = isPresent
        case let .setRecords(records):
            state.records = records
        case let .newRecordAdded(record):
            state.addRecordFormPresented = false
            state.records.insert(record, at: 0)
        }
    }
}

enum RecordViewAsyncAction: Effect {
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


let recordViewReducer = RecordViewReducer()
