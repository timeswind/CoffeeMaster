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
import FASwiftUI

struct keyValue<T1, T2> {
    var key: T1
    var value: T2
}

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var keyboard: KeyboardResponder

    @State var selectedLanguage = ""
    @EnvironmentObject var environmentWindowObject: EnvironmentWindowObject
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    @State var username = ""

    var settingsState: SettingsState
    
    func onAppear() {
        self.username = store.state.settings.name
    }

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
    
    func updateUsername() {
        let updateUsernameAction = SettingsAsyncAction.setUsername(username: self.username)
        store.send(updateUsernameAction)
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
        
        let allWeightUnitTypes = WeightUnit.standardWeightUnitTypes
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
                            Text(LocalizedStringKey(langugae.key)).tag(langugae.value)
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
                        HStack {
                            Text(LocalizedStringKey("EditUsername")).foregroundColor(.gray)
                            Spacer()
                            TextField(LocalizedStringKey("EditUsername"), text: $username, onCommit: {self.updateUsername()})
                        }

                        VStack {
                            Button(action: {self.logout()}) {
                                    Text(LocalizedStringKey("Logout"))
                            }
                        }
                    }
                }
            
            }.padding(.bottom, keyboard.currentHeight)
                .navigationBarTitle(LocalizedStringKey("Settings"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.exit()
                    }) {
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: "times", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("Dismiss")).fontWeight(.bold)
                        }
                })
        }.accentColor(Color(UIColor.Theme.Accent)).onAppear(perform: {self.onAppear()})
    }
}

