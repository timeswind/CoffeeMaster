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
    @State private var isLocationPickerPresented: Bool = false

    @State var showingImagePicker = false
    @State var images : [UIImage] = []
    
    @State var addCoffeeCollection = false
    @State private var location: Location?

    func record() {
        assert(store.state.settings.uid != nil)
        var record = Record(title: recordTitle, body: recordBody, created_by_uid: store.state.settings.uid!)
        record.images = self.images.map { $0.jpegData(compressionQuality: 80)! }
        record.location = self.location
        store.send(RecordViewAsyncAction.addRecord(record: record))
        self.exit()
    }
    
    func addImage(image: UIImage) {
        // Only allow maxium 9 images
        if (self.images.count < 9) {
            self.images.append(image)
        }
    }
    
    func removeImage(at Index: Int) {
        self.images.remove(at: Index)
    }
    
    func showLocationPicker() {
        self.isLocationPickerPresented = true
    }
    
    func onPickLocation (_ location: Location) {
        self.isLocationPickerPresented = false
        self.location = location
    }
    
    //    func dismissSelf() {
    //        store.send(.recordview(action: .setAddRecordFormPresentStatus(isPresent: false)))
    //    }
    
    func exit() {
        self.images = []
        store.send(.recordview(action: .setRecordFormIsPresent(status: false)))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                TextField(LocalizedStringKey("NewRecordTitle"), text: $recordTitle)
                MultilineTextField(LocalizedStringKey("NewRecordBody"), text: $recordBody, onCommit: {
                    print("Final text: \(self.recordBody)")
                })
                
                if (self.images.count < 9) {
                    
                    Button("Show image picker") {
                        self.showingImagePicker = true
                    }
                }
                
                if (self.location == nil) {
                    Button("Show location picker") {
                        self.showLocationPicker()
                    }
                } else {
                    LocationCardView(location: self.location!).frame(height: 200)
                }
                
                ZStack {
                    GridStack(minCellWidth: 100, spacing: 2, numItems: self.images.count) { index, cellWidth in
                        Image(uiImage: self.images[index])
                            .resizable()
                            .frame(width: cellWidth, height: cellWidth)
                            .onTapGesture {
                                self.removeImage(at: index)
                        }
                    }
                }.scaledToFill()
                

                
                if (self.addCoffeeCollection) {
                    VStack {
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                        Text("CoffeeCollectionForm")
                    }
                }
                
                Toggle(isOn: $addCoffeeCollection) {
                    Text(LocalizedStringKey("AddCoffeeCollection"))
                }
                
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
                if (image != nil) {
                    self.addImage(image: image!)
                }
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
        }.sheet(isPresented: $isLocationPickerPresented) {
            LocationPickerView(onPickLocation: { (location) in
                self.onPickLocation(location)
            }, onCancel: {
                self.isLocationPickerPresented = false
            }).modifier(EnvironmemtServices())
        }
        .accentColor(Color(UIColor.Theme.Accent))
        
    }
}
