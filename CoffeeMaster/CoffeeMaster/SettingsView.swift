//
//  SettingsView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct keyValue<T1, T2> {
    var key: T1
    var value: T2
}

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var selectedLanguage = ""
    @EnvironmentObject var environmentWindowObject: EnvironmentWindowObject
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil

    
    var settingsState: SettingsState

    func updateLocalization() {
        let updateAction: AppAction = .settings(action: .setLocalization(localization: selectedLanguage))
        store.send(updateAction)
    }
    
    func logout() {
        let logoutAction: AppAction = .settings(action: .logout(with: true))
        store.send(logoutAction)
    }
    
    func exit() {
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    func update(weightUnit: WeightUnit) {
        let updateAction: AppAction = .settings(action: .setWeightUnit(weightUnit: weightUnit))
        store.send(updateAction)
    }
    
    func update(temperatureUnit: TemperatureUnit) {
        let updateAction: AppAction = .settings(action: .setTemperatureUnit(temperatureUnit: temperatureUnit))
        store.send(updateAction)
    }
        
    var body: some View {
        let supportedLanguages = self.settingsState.supportedLanguages.map { (arg0) -> keyValue<String, String> in
            let (key, value) = arg0
            return keyValue<String, String>(key: key, value: value)
        }
        
        let allWeightUnitTypes = WeightUnit.allValues
        let allTemperatureUnitTypes = TemperatureUnit.allValues
        
        
        let weightUnitValueBind = Binding<WeightUnit>(get: {
            return self.store.state.settings.weightUnit
        }, set: {
            self.update(weightUnit: $0)
        })
        
        let temperatureUnitValueBind = Binding<TemperatureUnit>(get: {
            return self.store.state.settings.temperatureUnit
        }, set: {
            self.update(temperatureUnit: $0)
        })
        
        let isUserSignedIn = store.state.settings.signedIn
        
        let p = Binding<String>(get: {
            return self.store.state.settings.localization
        }, set: {
            self.selectedLanguage = $0
            self.updateLocalization()
        })
        
        return NavigationView{
            Form {
                Section(header: Text(LocalizedStringKey("General"))) {
                    Picker(selection: p, label: Text(LocalizedStringKey("ChooseLanguage"))) {
                        ForEach(supportedLanguages, id: \.value) { langugae in
                            Text(langugae.key).tag(langugae.value)
                        }
                    }
                }
                
                Section(header: Text(LocalizedStringKey("SettingsWeightUnit"))) {
                    Picker(selection: weightUnitValueBind, label: Text("ConfigureWeightUnitPickerLabel")) {
                        ForEach(allWeightUnitTypes, id: \.self) { weightUnitType in
                            VStack {
                                Text(LocalizedStringKey(weightUnitType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text(LocalizedStringKey("SettingsTemperatureUnit"))) {
                    Picker(selection: temperatureUnitValueBind, label: Text("ConfigureTemperatureUnitPickerLabel")) {
                        ForEach(allTemperatureUnitTypes, id: \.self) { temperatureUnitType in
                            VStack {
                                Text(LocalizedStringKey(temperatureUnitType.rawValue))
                            }
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text(LocalizedStringKey("Account"))) {
                    if (!isUserSignedIn) {
                        VStack {
                            SignInWithAppleView()
                        }
                    } else {
                        VStack {
                            Button(action: {self.logout()}) {
                                    Text(LocalizedStringKey("Logout"))
                            }}
                    }
                }
            
            }.navigationBarTitle(LocalizedStringKey("Settings"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.exit()
                    }) {
                        Text(LocalizedStringKey("Dismiss"))
                })
        }.accentColor(Color(UIColor.Theme.Accent))
    }
    
//    private func showAppleLogin() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName]
//        let nounce = Utilities.randomNonceString()
//        request.nonce = Utilities.sha256(nounce)
//        performSignIn(using: [request], nounce: nounce)
//    }
//
//    private func performSignIn(using requests: [ASAuthorizationRequest], nounce: String) {
//        appleSignInDelegates = SignInWithAppleDelegates(window: environmentWindowObject.window, nounce: nounce) { success in
//            if success {
//              // update UI
//                if Auth.auth().currentUser != nil {
//                    self.store.send(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
//                    self.store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
//                 }
//            } else {
//              // show the user an error
//            }
//        }
//
//        let controller = ASAuthorizationController(authorizationRequests: requests)
//      controller.delegate = appleSignInDelegates
//      controller.presentationContextProvider = appleSignInDelegates
//      controller.performRequests()
//    }
}

