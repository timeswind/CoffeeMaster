//
//  ContentView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine

struct RepoRow: View {
    let repo: Repo

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.description ?? "")
                    .font(.subheadline)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var query: String = "Swift"

    var body: some View {
        SearchView(
            query: $query,
            repos: store.state.repostate.searchResult,
            onCommit: fetch
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(RepoSideEffect.repoSearch(query: query))
    }
}

struct SearchView : View {
    @Binding var query: String
    let repos: [Repo]
    let onCommit: () -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("Type something", text: $query, onCommit: onCommit)

                if repos.isEmpty {
                    Text("Loading...")
                } else {
                    ForEach(repos) { repo in
                        RepoRow(repo: repo)
                    }
                }
            }.navigationBarTitle(Text("Search"))
        }
    }
}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var selection = 0
//
//    var body: some View {
//        TabView(selection: $selection){
//            Text("First View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("first")
//                        Text("First")
//                    }
//                }
//                .tag(0)
//            Text("Second View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("second")
//                        Text("Second")
//                    }
//                }
//                .tag(1)
//        }
//    }
//}
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
