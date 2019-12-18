//
//  PostFormView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct PostFormView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var keyboard: KeyboardResponder
    
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var postAllowComment: Bool = true
    @State private var isLocationPickerPresented: Bool = false
    
    @State private var showingImagePicker = false
    @State private var images : [UIImage] = []
    
    @State private var location: Location?
    
    @State private var brewGuide: BrewGuide?
    
    func viewDidAppear() {
        if let composting_post = store.state.connectViewState.composing_post {
            if let brewGuide = composting_post.brewGuide {
                self.brewGuide = brewGuide
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func post() {
        assert(store.state.settings.uid != nil)
        
        var post: Post!
        
        if let composting_post = store.state.connectViewState.composing_post {
            post = composting_post
            post.title = postTitle
            post.body = postBody
            post.created_by_uid = store.state.settings.uid!
            post.allow_comment = self.postAllowComment
        } else {
            post = Post(title: postTitle, body: postBody, created_by_uid: store.state.settings.uid!, allow_comment: self.postAllowComment)
        }
        
        
        post.images = self.images.map { $0.jpegData(compressionQuality: 80)! }
        post.location = self.location
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
    }
    
    func removeLocation() {
        self.location = nil
    }
    
    func exit() {
        store.send(.connectview(action: .setNewPostFormPresentStatus(isPresent: false)))
        //        UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: { })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    TextField(LocalizedStringKey("NewPostTitle"), text: $postTitle)
                    MultilineTextField(LocalizedStringKey("NewPostBody"), text: $postBody, onCommit: {})
                    
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
                    
                    VStack {
                        if (self.brewGuide != nil) {
                            BrewGuideCardView(brewGuide: self.brewGuide!)
                        }
                    }
                    
                    Toggle(isOn: $postAllowComment) {
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: self.postAllowComment ? "comment" : "comment-slash", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("NewPostAllowComment")).fontWeight(.bold)
                        }
                    }
                    Spacer()
                }.onTapGesture {
                    self.endEditing()
                }
                .padding([.horizontal, .top],20)
                .navigationBarTitle(Text(LocalizedStringKey("NewPost")))
                .navigationBarItems(leading:
                    Button(action: {self.exit()}) {
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: "times", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("Dismiss")).fontWeight(.bold)
                        }
                    }
                    ,trailing: Button(action: {self.post()}) {
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: "feather-alt", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("NewPostPostAction")).fontWeight(.bold)
                        }
                    }
                )
                    .sheet(isPresented: $showingImagePicker,
                           onDismiss: {
                            if self.showingImagePicker == true {
                                self.showingImagePicker = false
                            }
                    }, content: {
                        ImagePicker.shared.view
                    }).onReceive(ImagePicker.shared.$image) { image in
                        if (image != nil) {
                            self.addImage(image: image!)
                        }
                }
            }.padding(.bottom, self.keyboard.currentHeight + 40)

        }.onAppear(perform: {
            self.viewDidAppear()
        })
            .sheet(isPresented: $isLocationPickerPresented) {
                LocationPickerView(onPickLocation: { (location) in
                    self.onPickLocation(location)
                }, onCancel: {
                    self.isLocationPickerPresented = false
                }).modifier(EnvironmemtServices())
        }
        .accentColor(Color(UIColor.Theme.Accent))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct PostFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        PostFormView().modifier(EnvironmemtServices())
    }
}
