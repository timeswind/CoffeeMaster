//
//  App.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Combine

enum RepoSideEffect: Effect {
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
enum AppAction {
    case repos(repos: ReposAction)
    case settings(action: SettingsAction)
}

enum SettingsAction {
    case setName(name: String)
}

enum ReposAction {
    case setSearchResults(repos: [Repo])
}


let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .settings(action):
        settingsReducer.reduce(&state.settings, action)
    case let .repos(action):
        reposReducer.reduce(&state.repostate, action)
    }
}

let reposReducer: Reducer<ReposState, ReposAction> = Reducer { state, action in
    switch action {
    case let .setSearchResults(repos):
        state.searchResult = repos
    }
}

let settingsReducer: Reducer<SettingsState, SettingsAction> = Reducer { state, action in
    switch action {
    case let .setName(name):
        state.name = name
    }
}


struct ReposState {
    var searchResult: [Repo] = []
}


struct SettingsState {
    var name: String = ""
}

struct AppState {
    var settings: SettingsState
    var repostate: ReposState
}

//struct AppState {
//    var searchResult: [Repo] = []
//}

//let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
//    switch action {
//    case let .setSearchResults(repos):
//        state.searchResult = repos
//    }
//}
