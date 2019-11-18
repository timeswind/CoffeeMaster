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
    
    func post() {
        
    }
    var body: some View {
        NavigationView {
        RecordListView().navigationBarTitle(Text(LocalizedStringKey("Record"))).navigationBarItems(
                            trailing:
                                Button(action: {self.post()}) {
                                    Text(LocalizedStringKey("Write"))
                                })
        }
    }
}

struct RecordListView: View {
    var body: some View {
        List {
            Text("RecordListView")
        }
    }
}
