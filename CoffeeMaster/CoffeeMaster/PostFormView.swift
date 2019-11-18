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
    @Binding var showModal: Bool
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var postAllowComment: Bool = true
    
    func post() {
        assert(store.state.settings.uid != nil)
        let post = Post(title: postTitle, body: postBody, created_by_uid: store.state.settings.uid!, allow_comment: true)
        let updatePostAction: AppAction = .connectview(action: .setCurrentEditingPost(post: post))

        store.send(updatePostAction)
        store.send(AsyncSideEffect.newPost(post: post))
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
                    Button(action: {self.showModal.toggle()}) {
                        Text(LocalizedStringKey("Dismiss"))
                    }
                    ,trailing: Button(action: {self.post()}) {
                        Text(LocalizedStringKey("NewPostPostAction"))
                    }
            )
        }.accentColor(Color(UIColor.Theme.Accent))
        
    }
}

struct MultilineTextField: View {
    
    private var placeholder: LocalizedStringKey
    private var onCommit: (() -> Void)?
    
    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }
    
    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    
    init (_ placeholder: LocalizedStringKey = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }
    
    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .overlay(placeholderView, alignment: .topLeading)
    }
    
    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(Color(UIColor.init(netHex: 0xcccccc)))
                    .padding(.top, 8)
            }
        }
    }
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator
        
        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        if nil != onDone {
            textField.returnKeyType = .done
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        //        if uiView.window != nil, !uiView.isFirstResponder {
        //            uiView.becomeFirstResponder()
        //        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        
        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            //            if let onDone = self.onDone, text == "\n" {
            //                textView.resignFirstResponder()
            //                onDone()
            //                return false
            //            }
            return true
        }
    }
    
}
