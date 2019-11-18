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
        ).onAppear(perform: fetch).environment(\.locale, .init(identifier: store.state.settings.localization))
    }

    private func fetch() {
        store.send(RepoSideEffect.repoSearch(query: query))
    }
}

struct SearchView : View {
    @State private var selection = 0
    @Binding var query: String
    let repos: [Repo]
    let onCommit: () -> Void
    
    var body: some View {
                TabView(selection: $selection){
                        ExploreView()
                        .tabItem {
                            if (selection == 0) {
                                VStack {
                                    Image("explore-icon-select-100")
                                    Text("Explore")
                                }
                            } else {
                                VStack {
                                    Image("explore-icon-unselect-100")
                                    Text("Explore")
                                }
                            }
                        }
                        .tag(0)
                    NavigationView{
                        BrewSectionView().navigationBarTitle(Text("Brew"))
                    }.tabItem {
                        if (selection == 1) {
                            VStack {
                                Image("make-icon-select-100")
                                Text("Brew")
                            }
                        } else {
                            VStack {
                                Image("make-icon-unselect-100")
                                Text("Brew")
                            }
                        }
                    }
                    .tag(1)

                    ConnectView()
                    .tabItem {
                        if (selection == 2) {
                            VStack {
                                Image("community-icon-select-100")
                                Text(LocalizedStringKey("Connect"))
                            }
                        } else {
                            VStack {
                                Image("community-icon-unselect-100")
                                Text(LocalizedStringKey("Connect"))
                            }
                        }
                    }
                    .tag(2)
                    RecordView()
                    .tabItem {
                        if (selection == 3) {
                            VStack {
                                Image("record-icon-select-100")
                                Text(LocalizedStringKey("Connect"))
                            }
                        } else {
                            VStack {
                                Image("record-icon-unselect-100")
                                Text(LocalizedStringKey("Connect"))
                            }
                        }
                    }
                    .tag(3)
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

                    }.tag(4)
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("Test")
                        }
                    }
                    }.accentColor(Color(UIColor.Theme.Accent))
                    .edgesIgnoringSafeArea(.top)
    }
}
