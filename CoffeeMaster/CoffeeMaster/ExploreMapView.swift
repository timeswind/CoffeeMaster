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
    @EnvironmentObject var store: Store<AppState, AppAction>
//    @State var annotations: [MGLPointAnnotation] = []
    @State var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D.init()
    
    func fetchLocationObjects() {
        store.send(ConnectViewAsyncAction.getAllPosts(query: ""))
        store.send(RecordViewAsyncAction.getMyRecords(query: ""))
    }

    private func mapRegionDidChange() {
        
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
        
        return ThemeMapView(annotations: annotations, centerCoordinate: $centerCoordinate, regionDidChange: {
            self.mapRegionDidChange()
        }).onAppear {
            self.fetchLocationObjects()
        }
    }
}

struct AExploreMapView_Previews: PreviewProvider {
    
    static var previews: some View {
           ExploreMapView().modifier(EnvironmemtServices())
    }
}


