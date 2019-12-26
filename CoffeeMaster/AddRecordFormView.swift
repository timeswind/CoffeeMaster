//
//  AddRecordForm.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct AddRecordFormView: View {
    @EnvironmentObject var keyboard: KeyboardResponder
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.editMode) var mode

    @State private var recordTitle: String = ""
    @State private var recordBody: String = ""
    @State private var isLocationPickerPresented: Bool = false

    @State var showingImagePicker = false
    @State var images : [UIImage] = []
    
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
    
    func removeLocation() {
        self.location = nil
    }
    
    func exit() {
        self.images = []
        store.send(.recordview(action: .setRecordFormIsPresent(status: false)))
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    var body: some View {
        let isEditMode = !(self.mode?.wrappedValue == .inactive)
        
        return
            NavigationView {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        TextField(LocalizedStringKey("NewRecordTitle"), text: $recordTitle)
                        MultilineTextField(LocalizedStringKey("NewRecordBody"), text: $recordBody, onCommit: {})
                        
                        if (self.images.count < 9) {
                            Button(action: {
                                self.showingImagePicker = true
                            }) {
                                HStack {
                                    FAText(iconName: "images", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)

                                    Text(LocalizedStringKey("AddImage"))
                                        .fontWeight(.bold)
                                        .font(.body)
                                        .padding(.all, 8)
                                        .background(Color(UIColor.Theme.Accent))
                                        .cornerRadius(5)
                                        .foregroundColor(.white)
                                }
                            }.padding(.bottom)

                        }
                        
                        if (self.location == nil) {
                            Button(action: {
                                self.showLocationPicker()
                            }) {
                                HStack {
                                    FAText(iconName: "location-arrow", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                                    Text(LocalizedStringKey("AddLocation"))
                                        .fontWeight(.bold)
                                        .font(.body)
                                        .padding(.all, 8)
                                        .background(Color(UIColor.Theme.Accent))
                                        .cornerRadius(5)
                                        .foregroundColor(.white)
                                }
                            }

                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                LocationCardView(location: self.location!).frame(height: 200)
                                Button(action: {
                                    self.removeLocation()
                                }) {
                                    HStack {
                                        FAText(iconName: "times", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                                        Text(LocalizedStringKey("RemoveLocation"))
                                            .fontWeight(.bold)
                                            .font(.body)
                                            .padding(.all, 8)
                                            .background(Color(UIColor.Theme.Accent))
                                            .cornerRadius(5)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        
                        GridStack(minCellWidth: 100, spacing: 2, numItems: self.images.count) { index, cellWidth in
                            Image(uiImage: self.images[index])
                                .resizable()
                                .frame(width: cellWidth, height: cellWidth)
                                .onTapGesture {
                                    self.removeImage(at: index)
                            }
                        }
                        
                        Spacer()
                    }.onTapGesture {
                        self.endEditing()
                    }
                    .padding([.horizontal, .top],20)
                    .navigationBarTitle(Text(LocalizedStringKey(isEditMode ? "EditRecord" : "NewRecord")))
                    .navigationBarItems(leading:
                        Button(action: {self.exit()}) {
                            HStack(alignment: .bottom, spacing: 0) {
                                FAText(iconName: "times", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                                Text(LocalizedStringKey("Dismiss")).fontWeight(.bold)
                            }
                        }
                        ,trailing: Button(action: {self.record()}) {
                            HStack(alignment: .bottom, spacing: 0) {
                                FAText(iconName: "paper-plane", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                                Text(LocalizedStringKey("NewRecordRecordAction")).fontWeight(.bold)
                            }
                        }
                    ).background(EmptyView().sheet(isPresented: $isLocationPickerPresented) {
                        LocationPickerView(onPickLocation: { (location) in
                            self.onPickLocation(location)
                        }, onCancel: {
                            self.isLocationPickerPresented = false
                        }).modifier(EnvironmemtServices())
                    }
                    .background(EmptyView()                .sheet(isPresented: $showingImagePicker,
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
                }))
            }.padding(.bottom, self.keyboard.currentHeight + 40)
        }.edgesIgnoringSafeArea(.bottom)

    }
}

struct AddRecordFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            AddRecordFormView()
        }.modifier(EnvironmemtServices())
    }
}

