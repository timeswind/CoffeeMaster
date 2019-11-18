//
//  State.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import MapKit

struct AppState {
    var settings: SettingsState
    var repostate: ReposState
    var exploreViewState: ExploreViewState
    var connectViewState: ConnectViewState
    var recordViewState: RecordViewState
}

struct ReposState {
    var searchResult: [Repo] = []
}

struct ExploreViewState {
    var map_coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var map_zoom_level: Int = 0
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
    var records: [Record] = []
    var addRecordFormPresented: Bool = false
}
