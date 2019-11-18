//
//  RecordView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    private func fetch() {
        store.send(ConnectViewAsyncAction.getAllPosts(query: ""))
    }
    
    func post() {
        store.send(.connectview(action: .setNewPostFormPresentStatus(isPresent: true)))
    }
    
    var body: some View {
        
        let isNewRecordFormPresenting = Binding<Bool>(get: { () -> Bool in
            return self.store.state.connectViewState.newPostFormPresented
        }) { (isPresented) in }
        
        return NavigationView {
            RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                trailing:
                Button(action: {self.post()}) {
                    Text(LocalizedStringKey("Write"))
            })
        }.sheet(isPresented: isNewRecordFormPresenting) {
            AddRecordFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct RecordListView: View {
    var body: some View {
        List {
            Text("RecordListView")
        }
    }
}
