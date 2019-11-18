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
        store.send(RecordViewAsyncAction.getMyRecords(query: ""))
    }
    
    func showRecordForm() {
        store.send(.recordview(action: .setAddRecordFormPresentStatus(isPresent: true)))
    }
    
    var body: some View {
        
        let isAddRecordFormPresenting = Binding<Bool>(get: { () -> Bool in
            return self.store.state.recordViewState.addRecordFormPresented
        }) { (isPresented) in }
        
        return NavigationView {
            RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                trailing:
                Button(action: {self.showRecordForm()}) {
                    Text(LocalizedStringKey("Write"))
            }).onAppear(perform: fetch)
        }.sheet(isPresented: isAddRecordFormPresenting) {
            AddRecordFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
    }
}

struct RecordListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    var body: some View {
        let records = store.state.recordViewState.records

        return List {
            ForEach(records, id: \.id) { record in
                Text(record.title)
            }
        }
    }
}
