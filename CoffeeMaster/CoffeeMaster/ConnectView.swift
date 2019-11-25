//
//  ConnectView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var isNewPostFormPresented: Bool = false

    
    private func fetch() {
        store.send(ConnectViewAsyncAction.getAllPosts(query: ""))
    }
    
    func post() {
//        store.send(.connectview(action: .setNewPostFormPresentStatus(isPresent: true)))
        self.isNewPostFormPresented = true
    }
    
    var body: some View {
        let isLoggedIn = store.state.settings.signedIn
//        let isNewPostFormPresenting = Binding<Bool>(get: { () -> Bool in
//            return self.store.state.connectViewState.newPostFormPresented
//        }) { (isPresented) in
//
//        }
        
        return NavigationView {
            if (isLoggedIn) {
                ConnectListView().navigationBarTitle(Text(LocalizedStringKey("Connect"))).navigationBarItems(
                    trailing:
                    Button(action: {self.post()}) {
                        Text(LocalizedStringKey("Post"))
                }).onAppear(perform: fetch)
            } else {
                VStack {
                    Text(LocalizedStringKey("SignInToJoinOurCommunity"))
                    SignInWithAppleView().frame(width: 200, height: 40, alignment: .center)
                    Spacer()
                }
            }

        }.sheet(isPresented: $isNewPostFormPresented) {
            PostFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct ConnectListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var body: some View {
        
        return ScrollView(.vertical, showsIndicators: false) {
            if (self.store.state.connectViewState.posts.count > 0) {
                ForEach(self.store.state.connectViewState.posts, id: \.id) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            PostCardView(post: post)
                        }.padding(.horizontal)
                }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
            } else {
                EmptyView()
            }
        }

    }
}
