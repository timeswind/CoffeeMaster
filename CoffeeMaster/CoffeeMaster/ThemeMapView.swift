//
//  ThemeMapView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/9/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Mapbox

extension MGLPointAnnotation {
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinate
    }
}

struct ThemeMapView: UIViewRepresentable {
    @Binding var annotations: [MGLPointAnnotation]
    
    var regionDidChange: ((CLLocationCoordinate2D) -> Void)?
    
//    @State private var centerAnnotation = MGLPointAnnotation(title: "CenterAnnotation", coordinate: .init())

    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/timeswind/ck3dviev005p11co4czyb7ncc"))

    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> ThemeMapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
    func zoomLevel(_ zoomLevel: Double) -> ThemeMapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    func styleURL(_ styleURL: URL) -> ThemeMapView {
        mapView.styleURL = styleURL
        return self
    }
    
    func makeCoordinator() -> ThemeMapView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ThemeMapView>) -> MGLMapView {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<ThemeMapView>) {
        
        self.updateAnnotations()
        
    }
    
    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations)
    }
    
    class Coordinator: NSObject, MGLMapViewDelegate {
        var control: ThemeMapView
        
        init(_ control: ThemeMapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
            
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
        
        func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
            // map did moved
            if let regionDidChange = self.control.regionDidChange {
                regionDidChange(mapView.centerCoordinate)
            }
        }
    }
}


struct ThemeMapView_Previews: PreviewProvider {
    static var center = CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06)
    @State static var annotations:[MGLPointAnnotation] = []
    static var previews: some View {
        ThemeMapView(annotations: $annotations, regionDidChange: { coor in
            print(coor)
        }).centerCoordinate(center).zoomLevel(0)
    }
}
