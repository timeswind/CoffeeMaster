//
//  RecordView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import FASwiftUI

struct RecordView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var isActionSheetShow: Bool = false
    
    var recordTypeActionSheet: ActionSheet {
        ActionSheet(
            title: Text(LocalizedStringKey("RecordTypeActionSheetTitle")),
            message: Text(LocalizedStringKey("RecordTypeActionSheetMessage")),
            buttons: [
                .default(Text(LocalizedStringKey("RecordTypeActionSheetNewRecord")), action: {
                    self.showRecordForm()
                }),
                .default(Text(LocalizedStringKey("RecordTypeActionSheetTrackCaffeine")), action: {
                    self.showCaffeineTracker()
                }),
                .cancel()
        ])
    }
    
    private func fetch() {
        store.send(RecordViewAsyncAction.getMyRecords(query: ""))
    }
    
    func showCaffeineTracker() {
        store.send(.recordview(action: .setCaffeineTrackerIsPresent(status: true)))
    }
    
    func hideCaffeineTracker() {
        store.send(.recordview(action: .setCaffeineTrackerIsPresent(status: false)))
    }
    
    func showRecordForm() {
        store.send(.recordview(action: .setRecordFormIsPresent(status: true)))
    }
    
    func hideRecordForm() {
        store.send(.recordview(action: .setRecordFormIsPresent(status: false)))
    }
    
    func showRecordTypeActionSheet() {
        self.isActionSheetShow = true
    }
    
    var body: some View {
        let isLoggedIn = store.state.settings.signedIn
        
        let isSheetPresented = Binding<Bool>(get: { () -> Bool in
            self.store.state.recordViewState.isAddRecordNoteFormPresented || self.store.state.recordViewState.isCaffeineTrackerPresented
        }) { (isPresented) in
            return
        }
        
        let isAddRecordNoteFormPresented = self.store.state.recordViewState.isAddRecordNoteFormPresented
        let isCaffeineTrackerPresented = self.store.state.recordViewState.isCaffeineTrackerPresented

        return NavigationView {
            if (isLoggedIn) {
                RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                    trailing: Button(action: {
                        self.showRecordTypeActionSheet()
                    }) {
                        HStack(alignment: .bottom, spacing: 0) {
                            FAText(iconName: "plus", size: 20, style: .solid).padding([.leading,], 0).padding(.trailing, 8)
                            Text(LocalizedStringKey("NewRecord")).fontWeight(.bold)
                        }
                }).onAppear(perform: fetch)
            } else {
                VStack {
                    Text(LocalizedStringKey("SignInToRecordSyncedAcrossDevices")).padding(.horizontal)
                    SignInWithAppleView().frame(width: 200, height: 40, alignment: .center)
                    Spacer()
                }
            }
        }
        .actionSheet(isPresented: $isActionSheetShow, content: {self.recordTypeActionSheet})
        .sheet(isPresented: isSheetPresented, onDismiss: {
            if (isAddRecordNoteFormPresented == true) {
                self.hideRecordForm()
            }
            
            if (isCaffeineTrackerPresented == true) {
                self.hideCaffeineTracker()
            }
        }) {
            if (isAddRecordNoteFormPresented) {
                AddRecordFormView().modifier(EnvironmemtServices())
            } else {
                CaffeineTrackerView(askPermission: true).modifier(EnvironmemtServices())
            }
        }
    }
}

struct RecordListView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var viewSegment = 0
    
    var body: some View {
        let records = store.state.recordViewState.records
        
        return ScrollView(.vertical, showsIndicators: false) {
            Picker(selection: $viewSegment, label: Text("RecordViewSegmentLabel")) {
                Text("Note").tag(0)
                Text("Collection").tag(1)
                Text("Tasting").tag(2)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
            
            if (viewSegment == 0) {
                if (self.store.state.recordViewState.records.count > 0) {
                    ForEach(records, id: \.id) { record in
                        NavigationLink(destination: Text("Record Detail")) {
                            RecordCardView(record: record)
                        }.padding(.horizontal)
                    }.listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))
                    .buttonStyle(PlainButtonStyle())
                } else {
                    EmptyView()
                }
            } else if (viewSegment == 1) {
                Text("CoffeeCollectionView")
            } else {
                Text("Tasting View")
            }
        }
    }
}
