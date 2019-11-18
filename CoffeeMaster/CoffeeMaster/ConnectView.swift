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
    
    private func fetch() {
        store.send(AsyncSideEffect.getAllPosts(query: ""))
    }
    
    func post() {
        store.send(.connectview(action: .setNewPostFormPresentStatus(isPresent: true)))
    }
    
    var body: some View {
        
        let isNewPostFormPresenting = Binding<Bool>(get: { () -> Bool in
            return self.store.state.connectViewState.newPostFormPresented
        }) { (isPresented) in
            
        }
        
        return NavigationView {
            ConnectListView().navigationBarTitle(Text(LocalizedStringKey("Connect"))).navigationBarItems(
                trailing:
                Button(action: {self.post()}) {
                    Text(LocalizedStringKey("Post"))
            }).onAppear(perform: fetch)
        }.sheet(isPresented: isNewPostFormPresenting) {
            PostFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct ConnectListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var body: some View {
        let posts = store.state.connectViewState.posts

        return List {
            ForEach(posts, id: \.id) { post in
                Text(post.title)
                    .padding()
            }
        }
    }
}
