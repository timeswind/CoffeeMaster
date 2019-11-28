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
    
    @State var showingImagePicker = false
    @State var image : Image? = nil
    
    func record() {
        assert(store.state.settings.uid != nil)
        let record = Record(title: recordTitle, body: recordBody, created_by_uid: store.state.settings.uid!)
        store.send(RecordViewAsyncAction.addRecord(record: record))
        self.exit()
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
                
                Button("Show image picker") {
                  self.showingImagePicker = true
                }
                
                image?
                    .resizable()
                    .frame(width: 200)

            
            Spacer()
        }.sheet(isPresented: $showingImagePicker,
                onDismiss: {
                    // do whatever you need here
                    // if ImagePicker.shared.image != nil {
                    //    shownNextScreen = true
                    // }
        }, content: {
            ImagePicker.shared.view
        }).onReceive(ImagePicker.shared.$image) { image in
            self.image = image
        }
            .padding(20)
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
