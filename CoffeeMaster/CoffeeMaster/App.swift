//
//  App.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine
import Firebase

enum AsyncSideEffect: Effect {
    case repoSearch(query: String)

    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .repoSearch(query):
            return dependencies.githubService
                .searchPublisher(matching: query)
                .replaceError(with: [])
                .map { let repoAction: ReposAction = .setSearchResults(repos: $0)
                    return AppAction.repos(repos: repoAction) }
                .eraseToAnyPublisher()
        }
    }
}

enum EmptyAction {
    case nilAction(nil: Bool)
}

enum AppAction {
    case repos(repos: ReposAction)
    case settings(action: SettingsAction)
    case connectview(action: ConnectViewAction)
    case recordview(action: RecordViewAction)
    case emptyAction(action: EmptyAction)
}

enum ReposAction {
    case setSearchResults(repos: [Repo])
}


let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .emptyAction(action):
        return
    case let .settings(action):
        settingsReducer.reducer.reduce(&state.settings, action)
    case let .repos(action):
        reposReducer.reduce(&state.repostate, action)
    case let .connectview(action):
        connectViewReducer.reducer.reduce(&state.connectViewState, action)
    case let .recordview(action):
        recordViewReducer.reducer.reduce(&state.recordViewState, action)
    }
}

let reposReducer: Reducer<ReposState, ReposAction> = Reducer { state, action in
    switch action {
    case let .setSearchResults(repos):
        state.searchResult = repos
    }
}

func getLocalization() -> String {
    if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
    }

    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    return lang!
}
