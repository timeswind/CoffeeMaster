//
//  MapView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

struct ExploreMapView: View {
    enum sheetViewType {
        case Post, Record, None
    }
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D.init()
    @State private var showSheet = false
    
    @State var sheetView: sheetViewType = .None
    @State var sheetData: Any? = nil
    
    func fetchLocationObjects() {
        if (store.state.settings.signedIn) {
            store.send(ConnectViewAsyncAction.getAllPosts(query: ""))
            store.send(RecordViewAsyncAction.getMyRecords(query: ""))
        }
    }
    
    func viewDidAppear() {
        self.fetchLocationObjects()
    }
    
    private func mapRegionDidChange() {
       // self.fetchLocationObjects()
    }
    
    func annotationOnClick(_ annotation: MGLPointAnnotation) {
        if (annotation is PostPointAnnotation) {
            self.sheetView = .Post
            self.sheetData = (annotation as! PostPointAnnotation).post
        } else if (annotation is RecordPointAnnotation) {
            self.sheetView = .Record
            self.sheetData = (annotation as! RecordPointAnnotation).record
        }
        self.showSheet = true
    }
    
    func getAnnotations(posts: [Post], records: [Record]) -> [MGLPointAnnotation] {
        var annotations: [MGLPointAnnotation] = []
        let postsWithLocation = posts.filter({ $0.location != nil })
        let recordsWithLocation = records.filter({ $0.location != nil })
        
        for post in postsWithLocation {
            let coordinate = post.location!.coordinate.toCLCoordinate2D()
            let subtitle = post.author_name ?? post.created_by_uid
            let postPointAnnotation = PostPointAnnotation(coordinate: coordinate, title: post.title, subtitle: subtitle, post: post)
            annotations.append(postPointAnnotation)
        }
        
        for record in recordsWithLocation {
            let coordinate = record.location!.coordinate.toCLCoordinate2D()
            
            let subtitle = (record.created_at != nil) ? Utilities.convertTimestampShort(date: record.created_at!.dateValue()) : ""
            let recordPointAnnotation = RecordPointAnnotation(coordinate: coordinate, title: record.title, subtitle: subtitle, record: record)
            annotations.append(recordPointAnnotation)
        }
        
        return annotations
    }
    
    var body: some View {
        let posts = store.state.connectViewState.posts
        let records = store.state.recordViewState.records
        let annotations = Binding<[MGLPointAnnotation]>(get: { () -> [MGLPointAnnotation] in
            return self.getAnnotations(posts: posts, records: records)
        }) { _ in }
        
        return ThemeMapView(annotations: annotations, centerCoordinate: $centerCoordinate, regionDidChange: {self.mapRegionDidChange()}, annotationOnClick: {(annotation) in self.annotationOnClick(annotation)}).onAppear(perform: {
            self.viewDidAppear()
        })
            
            .sheet(isPresented: $showSheet, onDismiss: {
            if (self.showSheet) {
                self.showSheet = false
            }
        }) {
            if (self.sheetView == .Post && self.sheetData != nil && self.sheetData is Post) {
                NavigationView {
                    PostDetailView(post: (self.sheetData as! Post)).navigationBarItems(leading: Button(action: {
                        self.showSheet = false
                    }){
                        Text(LocalizedStringKey("Dismiss"))
                    })
                }.modifier(EnvironmemtServices())
            } else  if (self.sheetView == .Record && self.sheetData != nil  && self.sheetData is Record) {
                  NavigationView {
                    NoteDetailView(record: (self.sheetData as! Record)).navigationBarItems(leading: Button(action: {
                        self.showSheet = false
                    }){
                        Text(LocalizedStringKey("Dismiss"))
                    })
                }.modifier(EnvironmemtServices())
            } else {
                EmptyView()
            }
        }
    }
}

struct ExploreMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        ExploreMapView().modifier(EnvironmemtServices())
    }
}


