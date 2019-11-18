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
    @State var isNewPostFormPresenting: Bool = false

    
    private func fetch() {
        store.send(RepoSideEffect.getAllPosts(query: ""))
    }
    
    func post() {
        self.isNewPostFormPresenting = true
    }
    
    var body: some View {
        NavigationView {
            ConnectListView().navigationBarTitle(Text(LocalizedStringKey("Connect"))).navigationBarItems(
                trailing:
                Button(action: {self.post()}) {
                    Text(LocalizedStringKey("Post"))
            }).onAppear(perform: fetch)
        }.sheet(isPresented: $isNewPostFormPresenting) {
            PostFormView(showModal: self.$isNewPostFormPresenting).environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct ConnectListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var body: some View {
        let posts = store.state.connectViewState.posts
        return List {
            ForEach(posts) { post in
                Text(post.title)
            }
        }
    }
}
