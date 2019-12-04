//
//  State.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import HealthKit

struct AppState {
    var settings: SettingsState
    var brewViewState: BrewViewState
    var connectViewState: ConnectViewState
    var recordViewState: RecordViewState
}

struct SettingsState {
    var name: String = ""
    var uid: String?
    var localization: String = ""
    var weightUnit: WeightUnit = .g
    var temperatureUnit: TemperatureUnit = .C
    var supportedLanguages: [String: String] = ["English": "en", "中文": "zh-Hans"]
    var signedIn: Bool = false
    var nounce:String?
    var isHealthKitEnabled = false
    var heathStore: HKHealthStore?
    var isHealthDataAccessGranted = false
    var healthSampleTypes: [HKSampleType] = []
    var mainTabViewSelectedTabIndex = 0
}

struct ConnectViewState {
    var posts: [Post] = []
    var comments: [String: [Comment]] = [:]
    var composing_post: Post?
    var newPostFormPresented: Bool = false
}

struct RecordViewState {
    var records: [Record] = []
    var addRecordFormPresented: Bool = false
}

struct BrewViewState {
    var defaultBrewGuides: [BrewGuide] = dependencies.defaultBrewingGuides.getGuides()
    var defaultBrewMethods: [BrewMethod] = dependencies.defaultBrewingGuides.getMethods()
    var myBrewGuides: [BrewGuide] = []
}
