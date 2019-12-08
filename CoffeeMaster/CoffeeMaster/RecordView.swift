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
    @State var isCaffeineTrackerPresented: Bool = false
    @State var isActionSheetShow: Bool = false
    var recordTypeActionSheet: ActionSheet {
        ActionSheet(
            title: Text(LocalizedStringKey("RecordTypeActionSheetTitle")),
            message: Text(LocalizedStringKey("RecordTypeActionSheetMessage")),
            buttons: [
                .default(Text("RecordTypeActionSheetNewRecord"), action: {
                    self.showRecordForm()
                }),
                .default(Text("RecordTypeActionSheetTrackCaffeine"), action: {
                    self.showCaffeineTracker()
                }),
                .cancel()
        ])
    }
    
    private func fetch() {
        store.send(RecordViewAsyncAction.getMyRecords(query: ""))
    }
    
    func showCaffeineTracker() {
        self.isCaffeineTrackerPresented = true
    }
    
    func showRecordForm() {
        self.isAddRecordFormPresented = true
    }
    
    func showRecordTypeActionSheet() {
        self.isActionSheetShow = true
    }
    
    var body: some View {
        let isLoggedIn = store.state.settings.signedIn
        
        return NavigationView {
            if (isLoggedIn) {
                RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                    trailing: Button(action: {
                        // change country setting
                        self.showRecordTypeActionSheet()
                    }) {
                        Text(LocalizedStringKey("NewRecord"))
                }).onAppear(perform: fetch)
            } else {
                VStack {
                    Text(LocalizedStringKey("SignInToRecordSyncedAcrossDevices")).padding(.horizontal)
                    SignInWithAppleView().frame(width: 200, height: 40, alignment: .center)
                    Spacer()
                }
            }
        }.actionSheet(isPresented: $isActionSheetShow, content: {self.recordTypeActionSheet})
            .sheet(isPresented: $isAddRecordFormPresented) {
                AddRecordFormView().environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
        }
        .sheet(isPresented: $isCaffeineTrackerPresented) {
            CaffeineTrackerView(askPermission: true).environmentObject(self.store).environment(\.locale, .init(identifier: self.store.state.settings.localization))
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
