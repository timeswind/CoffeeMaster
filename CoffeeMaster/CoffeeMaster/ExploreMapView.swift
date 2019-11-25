//
//  MapView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

struct ExploreMapView: UIViewRepresentable {
    private var mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/timeswind/ck3dviev005p11co4czyb7ncc"))
    
    func makeUIView(context: UIViewRepresentableContext<ExploreMapView>) -> MGLMapView {

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)

        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<ExploreMapView>) {
        
    }
}
