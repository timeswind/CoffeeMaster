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
    case setLocalization(localization: String)
    case setUserSignInStatus(isSignedIn: Bool)
    case setNounce(nounce: String)
    case logout(with: Bool)
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
    case let .setLocalization(string):
        Bundle.setLanguage(lang: string)
        state.localization = string
    case let .setUserSignInStatus(isSignedIn):
        state.signedIn = isSignedIn
    case let .setNounce(nounce):
        state.nounce = nounce
    case let .logout(with):
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            state.signedIn = false
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}


struct ReposState {
    var searchResult: [Repo] = []
}


struct SettingsState {
    var name: String = ""
    var localization: String = ""
    var supportedLanguages: [String: String] = ["English": "en", "中文": "zh-Hans"]
    var signedIn: Bool = false
    var nounce:String?
}

struct AppState {
    var settings: SettingsState
    var repostate: ReposState
}

func getLocalization() -> String {
    if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
    }

    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    return lang!
}
