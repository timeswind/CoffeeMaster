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

                    Text("Connect View")
                        .font(.title)
                        .tabItem {
                            if (selection == 2) {
                                VStack {
                                    Image("community-icon-select-100")
                                    Text("Connect")
                                }
                            } else {
                                VStack {
                                    Image("community-icon-unselect-100")
                                    Text("Connect")
                                }
                            }
                        }
                        .tag(2)
                    Text("Record View")
                        .font(.title)
                        .tabItem {
                            if (selection == 3) {
                                VStack {
                                    Image("record-icon-select-100")
                                    Text("Record")
                                }
                            } else {
                                VStack {
                                    Image("record-icon-unselect-100")
                                    Text("Record")
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
