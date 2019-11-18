//
//  SettingsReducer.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Firebase

enum SettingsAction {
    case setName(name: String)
    case setLocalization(localization: String)
    case setUserSignInStatus(isSignedIn: Bool)
    case setUserInfo(currentUser: User)
    case setNounce(nounce: String)
    case logout(with: Bool)
}

struct SettingsReducer {
    let reducer: Reducer<SettingsState, SettingsAction> = Reducer { state, action in
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
}

let settingsReducer = SettingsReducer()
