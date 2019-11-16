//
//  SettingsView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct keyValue<T1, T2> {
    var key: T1
    var value: T2
}

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var selectedLanguage = ""
    @Binding var showModal: Bool
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
        
    var body: some View {
        let supportedLanguages = self.settingsState.supportedLanguages.map { (arg0) -> keyValue<String, String> in
            let (key, value) = arg0
            return keyValue<String, String>(key: key, value: value)
        }
        
        let isUserSignedIn = store.state.settings.signedIn
        
        let p = Binding<String>(get: {
            return self.store.state.settings.localization
        }, set: {
            self.selectedLanguage = $0
            self.updateLocalization()
        })
        
        return NavigationView{
            Form {
                Section {
                    Picker(selection: p, label: Text(LocalizedStringKey("ChooseLanguage"))) {
                        ForEach(supportedLanguages, id: \.value) { langugae in
                            Text(langugae.key).tag(langugae.value)
                        }
                    }
                }
                
                if (!isUserSignedIn) {
                    VStack {
                        SignInWithApple().onTapGesture(perform: showAppleLogin)
                    }
                } else {
                    VStack {
                        Button(action: {self.logout()}) {
                                Text(LocalizedStringKey("Logout"))
                        }}
                }
            }.navigationBarTitle(LocalizedStringKey("Settings"))
                .navigationBarItems(trailing:
                    Button(action: {self.showModal.toggle()}) {
                        Text(LocalizedStringKey("Dismiss"))
                })
        }.environment(\.locale, .init(identifier: store.state.settings.localization))
    }
    
    private func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName]
        let nounce = Utilities.randomNonceString()
        request.nonce = Utilities.sha256(nounce)
        performSignIn(using: [request], nounce: nounce)
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest], nounce: String) {
        appleSignInDelegates = SignInWithAppleDelegates(window: environmentWindowObject.window, nounce: nounce) { success in
            if success {
              // update UI
                self.store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
            } else {
              // show the user an error
            }
        }

        let controller = ASAuthorizationController(authorizationRequests: requests)
      controller.delegate = appleSignInDelegates
      controller.presentationContextProvider = appleSignInDelegates
      controller.performRequests()
    }
}

final class SignInWithApple: UIViewRepresentable {
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton()
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}
