//
//  PostFormView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct PostFormView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var postAllowComment: Bool = true
    @State private var isLocationPickerPresented: Bool = false
    
    @State private var showingImagePicker = false
    @State private var images : [UIImage] = []
    
    @State private var location: Location?
    
    func post() {
        assert(store.state.settings.uid != nil)
        var post = Post(title: postTitle, body: postBody, created_by_uid: store.state.settings.uid!, allow_comment: self.postAllowComment)
        post.images = self.images.map { $0.jpegData(compressionQuality: 80)! }
        let updatePostAction: AppAction = .connectview(action: .setCurrentEditingPost(post: post))
        
        store.send(updatePostAction)
        store.send(ConnectViewAsyncAction.newPost(post: post))
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
        print(location)
    }
    
    func exit() {
        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField(LocalizedStringKey("NewPostTitle"), text: $postTitle)
                MultilineTextField(LocalizedStringKey("NewPostBody"), text: $postBody, onCommit: {
                    print("Final text: \(self.postBody)")
                })
                
                if (self.images.count < 9) {
                    
                    Button("Show image picker") {
                        self.showingImagePicker = true
                    }
                }
                
                if (self.location == nil) {
                    Button("Show location picker") {
                        self.isLocationPickerPresented = true
                    }
                } else {
                    LocationCardView(location: self.location!).frame(height: 200    )
                }
                
                GridStack(minCellWidth: 100, spacing: 2, numItems: self.images.count) { index, cellWidth in
                    Image(uiImage: self.images[index])
                        .resizable()
                        .frame(width: cellWidth, height: cellWidth)
                        .onTapGesture {
                            self.removeImage(at: index)
                    }
                }
                Toggle(isOn: $postAllowComment) {
                    Text(LocalizedStringKey("NewPostAllowComment"))
                }
                Spacer()
            }.padding(20)
                .navigationBarTitle(Text(LocalizedStringKey("NewPost")))
                .navigationBarItems(leading:
                    Button(action: {self.exit()}) {
                        Text(LocalizedStringKey("Dismiss"))
                    }
                    ,trailing: Button(action: {self.post()}) {
                        Text(LocalizedStringKey("NewPostPostAction"))
                    }
            )
                .sheet(isPresented: $showingImagePicker,
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

struct PostFormView_Previews: PreviewProvider {
    
    static var previews: some View {
           PostFormView().modifier(EnvironmemtServices())
    }
}
