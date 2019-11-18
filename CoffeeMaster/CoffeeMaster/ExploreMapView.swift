//
//  MapView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import MapKit

struct ExploreMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView;
    @Binding var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: UIViewRepresentableContext<ExploreMapView>) -> ExploreMapView.UIViewType {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<ExploreMapView>) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
        let region = MKCoordinateRegion(center: self.coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}
