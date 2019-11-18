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
            .getAllPosts()
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

enum EmptyAction {
    case nilAction(nil: Bool)
}

enum AppAction {
    case repos(repos: ReposAction)
    case settings(action: SettingsAction)
    case connectview(action: ConnectViewAction)
    case emptyAction(action: EmptyAction)
}

enum SettingsAction {
    case setName(name: String)
    case setLocalization(localization: String)
    case setUserSignInStatus(isSignedIn: Bool)
    case setUserInfo(currentUser: User)
    case setNounce(nounce: String)
    case logout(with: Bool)
}

enum ReposAction {
    case setSearchResults(repos: [Repo])
}

enum ConnectViewAction {
    case newPostAdded(post: Post)
    case setPosts(posts: [Post])
    case setCurrentEditingPost(post: Post)
}


let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .emptyAction(action):
        return
    case let .settings(action):
        settingsReducer.reduce(&state.settings, action)
    case let .repos(action):
        reposReducer.reduce(&state.repostate, action)
    case let .connectview(action):
        connectViewReducer.reduce(&state.connectViewState, action)
    }
}

let reposReducer: Reducer<ReposState, ReposAction> = Reducer { state, action in
    switch action {
    case let .setSearchResults(repos):
        state.searchResult = repos
    }
}

let connectViewReducer: Reducer<ConnectViewState, ConnectViewAction> = Reducer { state, action in
    switch action {
    case let .setPosts(posts):
        state.posts = posts
    case let .setCurrentEditingPost(post):
        state.composing_post = post
    case let .newPostAdded(post):
        state.posts.insert(post, at: 0)
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
    case let .setUserInfo(currentUser):
        state.uid = currentUser.uid
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


func getLocalization() -> String {
    if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
    }

    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    return lang!
}
