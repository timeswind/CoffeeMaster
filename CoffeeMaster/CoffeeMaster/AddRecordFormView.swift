//
//  AddRecordForm.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct AddRecordFormView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var postAllowComment: Bool = true
    
    func post() {
        assert(store.state.settings.uid != nil)
        let post = Post(title: postTitle, body: postBody, created_by_uid: store.state.settings.uid!, allow_comment: true)
        let updatePostAction: AppAction = .connectview(action: .setCurrentEditingPost(post: post))
        
        store.send(ConnectViewAsyncAction.newPost(post: post))
    }
    
    func dismissSelf() {
        store.send(.connectview(action: .setNewPostFormPresentStatus(isPresent: false)))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField(LocalizedStringKey("NewPostTitle"), text: $postTitle)
                MultilineTextField(LocalizedStringKey("NewPostBody"), text: $postBody, onCommit: {
                    print("Final text: \(self.postBody)")
                })
                Spacer()
            }.padding(20)
                .navigationBarTitle(Text(LocalizedStringKey("NewPost")))
                .navigationBarItems(leading:
                    Button(action: {self.dismissSelf()}) {
                        Text(LocalizedStringKey("Dismiss"))
                    }
                    ,trailing: Button(action: {self.post()}) {
                        Text(LocalizedStringKey("NewPostPostAction"))
                    }
            )
        }.accentColor(Color(UIColor.Theme.Accent))
        
    }
}
