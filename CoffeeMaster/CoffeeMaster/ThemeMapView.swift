//
//  ThemeMapView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/9/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

struct ThemeMapView: UIViewRepresentable {
    var center: CLLocationCoordinate2D
    
    init() {
        self.center = CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06)
    }
    
    init(center: CLLocationCoordinate2D) {
        self.center = center
    }
    
    func makeUIView(context: UIViewRepresentableContext<ThemeMapView>) -> MGLMapView {
        let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/timeswind/ck3dviev005p11co4czyb7ncc"))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(center, zoomLevel: 0, animated: false)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<ThemeMapView>) {
        
        if let oldAnnotations = uiView.annotations {
            uiView.removeAnnotations(oldAnnotations)
        }
        
        uiView.setCenter(self.center, animated: true)
    }
}

struct ThemeMapView_Previews: PreviewProvider {
    static var center = CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06)
    
    static var previews: some View {
        ThemeMapView()
    }
}
