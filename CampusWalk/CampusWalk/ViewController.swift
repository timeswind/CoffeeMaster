//
//  ViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import MapKit

class BuildingPin:MKPointAnnotation {
    var isFavorite: Bool = false
    var color:UIColor {return isFavorite ? UIColor.red : UIColor.blue}
    
    init(building: Building, isFavorite: Bool) {
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
        self.title = building.name
        self.isFavorite = isFavorite
    }
}


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BuildingTableViewControllerDelegate {

    let mapModel = MapModel.shared
    
    @IBOutlet weak var mapDisplayTypeButton: UIButton!
    @IBOutlet weak var toggleFavoriteBuildingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    var favoriteBuildingAnnotations:[BuildingPin] = []
    
    var showFavoriteBuildings:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        let delta = 0.014
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: mapModel.center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard

        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem
        
        self.toggleFavoriteBuildingsButton.setTitle("Hide Favorite Buildings", for: .normal)
        self.showFavoriteBuildings = true
        self.mapDisplayTypeButton.setTitle("Standard", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        setupButton()
    }
    
    func setupButton() {
        self.toggleFavoriteBuildingsButton.addShadow()
        self.mapDisplayTypeButton.addShadow()
    }

    func dismissed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleMapviewType(_ sender: Any) {
        
        switch self.mapView.mapType {
        case .standard:
            self.mapView.mapType = .hybrid
            self.mapDisplayTypeButton.setTitle("Hybrid", for: .normal)
        case .hybrid:
            self.mapView.mapType = .satellite
            self.mapDisplayTypeButton.setTitle("Satellite", for: .normal)
        case .satellite:
            self.mapView.mapType = .standard
            self.mapDisplayTypeButton.setTitle("Standard", for: .normal)
        default:
            break
        }
        
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        self.showFavoriteBuildings = !showFavoriteBuildings
        if (self.showFavoriteBuildings) {
        self.toggleFavoriteBuildingsButton.setTitle("Hide Favorite Buildings", for: .normal)
            self.addFavoriteBuildingsToMap()
        } else {
            self.toggleFavoriteBuildingsButton.setTitle("Show Favorite Buildings", for: .normal)
            self.removeFavoriteBuildingFromMap()
        }
    }
    
    func addFavoriteBuildingsToMap() {
        self.mapView.addAnnotations(self.favoriteBuildingAnnotations)
    }
    
    func removeFavoriteBuildingFromMap() {
        self.mapView.removeAnnotations(self.mapView.annotations.filter({ (annotation) -> Bool in
            if (annotation is BuildingPin) {
                let BAnnotation = annotation as! BuildingPin
                return BAnnotation.isFavorite
            } else {
                return false
            }
        }))
    }
    
    func dismissBySelect(building: Building) {
        self.dismiss(animated: true, completion: {
            self.addBuildingPin(building: building)
        })
    }
    
    func addBuildingPin(building: Building) {
        let buildingAnnotation = BuildingPin(building: building, isFavorite: false)
        self.mapView.removeAnnotations(self.mapView.annotations.filter({ (annotation) -> Bool in
            if (annotation is BuildingPin) {
                let BAnnotation = annotation as! BuildingPin
                return !BAnnotation.isFavorite
            } else {
                return true
            }
        }))
        
        self.mapView.addAnnotation(buildingAnnotation)
        
        let delta = 0.01
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: buildingAnnotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showBuildings":
            let nav = segue.destination as! UINavigationController
            let tableViewVC = nav.topViewController as! BuildingTableViewController
            tableViewVC.delegate = self
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is BuildingPin:
            let identifier = "buildingAnnotationView"
            let buildingAnnotation = annotation as! BuildingPin
            
            let annotationView: MKPinAnnotationView! = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView) ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView.pinTintColor = buildingAnnotation.color
            annotationView.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
            
            btn.addTarget(self, action: #selector(displayActionSheet), for: .touchUpInside)
            
            return annotationView
        case is MKUserLocation:
            return nil
        default:
            return nil
        }
    }
    
    func addToFavorite(annotation: BuildingPin) {
        self.mapView.removeAnnotation(annotation)
        annotation.isFavorite = true
        self.favoriteBuildingAnnotations.append(annotation)
        self.mapView.addAnnotation(annotation)
    }
    
    func removeFromFavorite(annotation: BuildingPin) {
        self.mapView.removeAnnotation(annotation)
        if let indexToRemove = self.favoriteBuildingAnnotations.firstIndex(where: { $0 == annotation }) {
            self.favoriteBuildingAnnotations.remove(at: indexToRemove)
            annotation.isFavorite = false
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    func deletePin(annotation: MKAnnotation) {
        self.mapView.removeAnnotation(annotation)
        if (annotation is BuildingPin && (annotation as! BuildingPin).isFavorite) {
            let BuildingAnnotation = annotation as! BuildingPin
            if let indexToRemove = self.favoriteBuildingAnnotations.firstIndex(where: { $0 == BuildingAnnotation }) {
                self.favoriteBuildingAnnotations.remove(at: indexToRemove)
                BuildingAnnotation.isFavorite = false
            }
        }
    }
    
    @objc func displayActionSheet(_ sender: Any) {
        if let annotation = self.mapView.selectedAnnotations.first {
            var favoriteAction: UIAlertAction = UIAlertAction(title: "Add Favorite", style: .default) { (UIAlertAction) in
                self.addToFavorite(annotation: annotation as! BuildingPin)
            }
            
            if (annotation is BuildingPin) {
                let buildingAnnotation = annotation as! BuildingPin
                if buildingAnnotation.isFavorite {
                    favoriteAction = UIAlertAction(title: "Remove Favorite", style: .default) { (UIAlertAction) in
                        let BuildingAnnotation = annotation as! BuildingPin
                        self.removeFromFavorite(annotation: BuildingAnnotation)
                    }
                    
                }
            }
             
            let optionMenu = UIAlertController(title: annotation.title!, message: "Choose Option", preferredStyle: .actionSheet)
                
             let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
                   self.deletePin(annotation: annotation)
            }
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(favoriteAction)
            optionMenu.addAction(cancelAction)
                
            self.present(optionMenu, animated: true, completion: nil)
        }

    }
    
//    func determineCurrentLocation()
//    {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        }
//    }
    
    // MARK: - MAPKIT DELEGATE
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            self.mapView.showsUserLocation = false
        }
    }
    
    // MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .restricted:
            let alertController = UIAlertController(title: "Location Service Restricted", message:
                 "Part of app's feature is restircted", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
             self.present(alertController, animated: true, completion: nil)
            break
        case .denied:
            let alertController = UIAlertController(title: "Location Service Denied", message:
                 "You can re-enable the location access in Settings app", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
             self.present(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}

