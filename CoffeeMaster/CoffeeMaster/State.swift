//
//  State.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

struct AppState {
    var settings: SettingsState
    var repostate: ReposState
    var connectViewState: ConnectViewState
}

struct ReposState {
    var searchResult: [Repo] = []
}

struct SettingsState {
    var name: String = ""
    var uid: String?
    var localization: String = ""
    var supportedLanguages: [String: String] = ["English": "en", "中文": "zh-Hans"]
    var signedIn: Bool = false
    var nounce:String?
}

struct ConnectViewState {
    var posts: [Post] = []
    var composing_post: Post?
    var newPostFormPresented: Bool = false
}

struct RecordViewState {
    var records: [Post] = []
    var newPostFormPresented: Bool = false
}
