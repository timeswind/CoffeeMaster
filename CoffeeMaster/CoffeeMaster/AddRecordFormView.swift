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
    @State private var recordTitle: String = ""
    @State private var recordBody: String = ""
    @State private var recordAllowComment: Bool = true
    
    func record() {
        assert(store.state.settings.uid != nil)
        let record = Record(title: recordTitle, body: recordBody, created_by_uid: store.state.settings.uid!)
        
        store.send(RecordViewAsyncAction.addRecord(record: record))
    }
    
//    func dismissSelf() {
//        store.send(.recordview(action: .setAddRecordFormPresentStatus(isPresent: false)))
//    }
    
    func exit() {
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField(LocalizedStringKey("NewRecordTitle"), text: $recordTitle)
                MultilineTextField(LocalizedStringKey("NewRecordBody"), text: $recordBody, onCommit: {
                    print("Final text: \(self.recordBody)")
                })
                Spacer()
            }.padding(20)
                .navigationBarTitle(Text(LocalizedStringKey("NewRecord")))
                .navigationBarItems(leading:
                    Button(action: {self.exit()}) {
                        Text(LocalizedStringKey("Dismiss"))
                    }
                    ,trailing: Button(action: {self.record()}) {
                        Text(LocalizedStringKey("NewRecordRecordAction"))
                    }
            )
        }.accentColor(Color(UIColor.Theme.Accent))
        
    }
}
