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
    @Binding var centerCoordinate: CLLocationCoordinate2D?
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/timeswind/ck3dviev005p11co4czyb7ncc"))
    
    var regionDidChange: (() -> Void)?
    var annotationOnClick: ((MGLPointAnnotation) -> Void)?

    
    init(annotations: Binding<[MGLPointAnnotation]>, centerCoordinate: Binding<CLLocationCoordinate2D?>, center: CLLocationCoordinate2D = CLLocationCoordinate2D.init(), regionDidChange: (() -> Void)? = nil, annotationOnClick: ((MGLPointAnnotation) -> Void)? = nil) {
        self._annotations = annotations
        self._centerCoordinate = centerCoordinate
        mapView.centerCoordinate = center
        self.regionDidChange = regionDidChange
        self.annotationOnClick = annotationOnClick
    }
    
    func makeUIView(context: UIViewRepresentableContext<ThemeMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let centerCoordinate = self.centerCoordinate {
            mapView.centerCoordinate = centerCoordinate
        }
//        if let centerCoordinate = self.centerCoordinate {
//            print("inti center coordinate")
//            mapView.centerCoordinate = centerCoordinate
//        }
        
         
        // Enable the permanent heading indicator, which will appear when the tracking mode is not `.followWithHeading`.
        mapView.showsUserLocation = true
        return mapView
    }
    
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
    
    func makeCoordinator() -> ThemeMapViewCoordinator {
        ThemeMapViewCoordinator(self)
    }
    
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<ThemeMapView>) {
        if let centerCoordinate = self.centerCoordinate {
            uiView.setCenter(centerCoordinate, animated: true)
        }
        if let currentAnnotations = uiView.annotations {
            uiView.removeAnnotations(currentAnnotations)
        }
        uiView.addAnnotations(self.annotations)
    }

}

class ThemeMapViewCoordinator: NSObject, MGLMapViewDelegate {
    var control: ThemeMapView
    
    init(_ control: ThemeMapView) {
        self.control = control
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        print("MapViewDidFinishLoading")
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        var imageView: MGLAnnotationImage!
        if (annotation is PostPointAnnotation) {
            imageView = MGLAnnotationImage(image: UIImage(named: "icons-chat-room-96")!, reuseIdentifier: reuseIdentifier)
        } else if (annotation is RecordPointAnnotation) {
            imageView = MGLAnnotationImage(image: UIImage(named: "icons-new-document-96")!, reuseIdentifier: reuseIdentifier)
        } else {
            imageView = MGLAnnotationImage(image: UIImage(named: "icons8-marker-100")!, reuseIdentifier: reuseIdentifier)
        }

        return imageView
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        if let annotationOnClick = self.control.annotationOnClick {
            annotationOnClick(annotation as! MGLPointAnnotation)
        }
    }

//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        print("viewFor annotation")
//        let reuseIdentifier = "\(annotation.coordinate.longitude)"
//
//        return MGLAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//
////        guard annotation is MGLPointAnnotation else {
////        return MGLAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
////        }
////
////        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
////
////            // If there’s no reusable annotation view available, initialize a new one.
////        if annotationView == nil {
////            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
////            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
////
////            // Set the annotation view’s background color to a value determined by its longitude.
////            let hue = CGFloat(annotation.coordinate.longitude) / 100
////            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
////            annotationView?.annotation = annotation
////        }
////
////        return annotationView
//    }
        
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        // map did moved
        self.control.centerCoordinate = mapView.centerCoordinate
        if let regionDidChange = self.control.regionDidChange {
            regionDidChange()
        }
    }
}

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
         
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}


struct ThemeMapView_Previews: PreviewProvider {
    static var center = CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06)
    @State static var annotations:[MGLPointAnnotation] = []
    @State static var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D.init()

    static var previews: some View {
        ThemeMapView(annotations: $annotations, centerCoordinate: $centerCoordinate, regionDidChange:nil).centerCoordinate(center).zoomLevel(0)
    }
}
