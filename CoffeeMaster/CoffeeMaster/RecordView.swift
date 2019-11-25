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
    @State var isAddRecordFormPresented: Bool = false

    private func fetch() {
        store.send(RecordViewAsyncAction.getMyRecords(query: ""))
    }
    
    func showRecordForm() {
        self.isAddRecordFormPresented = true
    }
    
    var body: some View {
        let isLoggedIn = store.state.settings.signedIn
        
        return NavigationView {
            if (isLoggedIn) {
                RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                    trailing:
                    Button(action: {self.showRecordForm()}) {
                        Text(LocalizedStringKey("Write"))
                }).onAppear(perform: fetch)
            } else {
                VStack {
                    Text(LocalizedStringKey("SignInToRecordSyncedAcrossDevices"))
                    SignInWithAppleView().frame(width: 200, height: 40, alignment: .center)
                    Spacer()
                }
            }
        }.sheet(isPresented: $isAddRecordFormPresented) {
            AddRecordFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct RecordListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var body: some View {
        let records = store.state.recordViewState.records

        return ScrollView(.vertical, showsIndicators: false) {
            if (self.store.state.recordViewState.records.count > 0) {
                ForEach(records, id: \.id) { record in
                        NavigationLink(destination: Text("Record Detail")) {
                            RecordCardView(record: record)
                        }.padding(.horizontal)
                }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
            } else {
                EmptyView()
            }
        }
    }
}
