//
//  SignInWithAppleView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SignInWithAppleView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var environmentWindowObject: EnvironmentWindowObject
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    
    func logout() {
        let logoutAction: AppAction = .settings(action: .logout(with: true))
        store.send(logoutAction)
    }

    var body: some View {
        VStack {
            SignInWithApple().onTapGesture(perform: showAppleLogin)
        }
        
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
                if Auth.auth().currentUser != nil {
                    self.store.send(.settings(action: .setUserInfo(currentUser: Auth.auth().currentUser!)))
                    self.store.send(.settings(action: .setUserSignInStatus(isSignedIn: true)))
                 }
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

