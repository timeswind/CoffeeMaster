//
//  SettingsReducer.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Firebase
import Combine
import HealthKit

enum SettingsActionError: Error, LocalizedError {
    case failToUpdateUsername
    public var errorDescription: String? {
        switch self {
        case .failToUpdateUsername:
            return NSLocalizedString("Fail to update username", comment: "")
        }
    }
}


enum SettingsAction {
    case setName(name: String)
    case setLocalization(localization: String)
    case setWeightUnit(weightUnit: WeightUnit)
    case setTemperatureUnit(temperatureUnit: TemperatureUnit)
    case setUserSignInStatus(isSignedIn: Bool)
    case setUserInfo(currentUser: User)
    case setNounce(nounce: String)
    case logout(with: Bool)
    case onError(error: Error)
    case enableHealthkit(store: HKHealthStore)
}

struct SettingsReducer {
    let reducer: Reducer<SettingsState, SettingsAction> = Reducer { state, action in
        switch action {
        case let .setName(name):
            state.name = name
        case let .setLocalization(string):
            Bundle.setLanguage(lang: string)
            state.localization = string
        case let .setWeightUnit(weightUnit):
            setWeightUnit(weightUnit: weightUnit)
            state.weightUnit = weightUnit
        case let .setTemperatureUnit(temperatureUnit):
            setTemperatureUnit(temperatureUnit: temperatureUnit)
            state.temperatureUnit = temperatureUnit
        case let .setUserSignInStatus(isSignedIn):
            state.signedIn = isSignedIn
        case let .setUserInfo(currentUser):
            state.uid = currentUser.uid
            state.name = currentUser.displayName ?? ""
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
        case let .onError(error):
            print(error.localizedDescription)
        case let .enableHealthkit(store):
            state.isHealthKitEnabled = true
            state.heathStore = store
        }
    }
}

enum SettingsAsyncAction: Effect {
    case setUsername(username: String)
    
    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .setUsername(username):
            return dependencies.webDatabaseQueryService
                .updateUsername(username: username)
                .replaceError(with: "error")
                .map {
                    if ($0 == "error") {
                        return AppAction.settings(action: .onError(error: SettingsActionError.failToUpdateUsername))
                    } else {
                        let settingsAction: SettingsAction = .setName(name: $0)
                        return AppAction.settings(action: settingsAction)
                    }
                    
            }
            .eraseToAnyPublisher()
        }
    }
}

let settingsReducer = SettingsReducer()
