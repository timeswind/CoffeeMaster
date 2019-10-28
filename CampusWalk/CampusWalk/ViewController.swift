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
    var isNavigation: Bool = false
    var isDestination: Bool = false
    var isSource: Bool = false
    var color:UIColor {return isFavorite ? UIColor.red : UIColor.blue}
    var building:Building!
    
    init(building: Building, isFavorite: Bool) {
        super.init()
        self.building = building
        self.coordinate = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
        self.title = building.name
        self.isFavorite = isFavorite
    }
}

class DirectionPolyline : MKPolyline {
    var color: UIColor = .blue
}


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BuildingViewControllerDelegate {

    let mapModel = MapModel.shared
    
    @IBOutlet weak var mapDisplayTypeButton: UIButton!
    @IBOutlet weak var toggleFavoriteBuildingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    var favoriteBuildingAnnotations:[BuildingPin] = []
    
    @IBOutlet weak var clearDirectionButton: UIButton!
    var showFavoriteBuildings:Bool = true
    var direction:Bool = false
    var selectedBuilding:MKMapItem?
    
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
        self.clearDirectionButton.isHidden = true
        self.clearDirectionButton.setTitle("Clear Direction", for: .normal)
        self.toggleFavoriteBuildingsButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        setupButton()
    }
    
    func setupButton() {
        self.clearDirectionButton.addShadow()
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
    
    @IBAction func clearDirection(_ sender: Any) {
        self.clearNavigation()
        self.clearDirectionButton.isHidden = true
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        if (self.showFavoriteBuildings) {
            self.setFavoriteBuildingsHidden()
        } else {
            self.setFavoriteBuildingsVisiable()
        }
    }
    
    func setFavoriteBuildingsVisiable() {
        self.showFavoriteBuildings = true
        self.toggleFavoriteBuildingsButton.setTitle("Hide Favorite Buildings", for: .normal)
        self.addFavoriteBuildingsToMap()
    }
    
    func setFavoriteBuildingsHidden() {
        self.showFavoriteBuildings = false
        self.toggleFavoriteBuildingsButton.setTitle("Show Favorite Buildings", for: .normal)
        self.removeFavoriteBuildingFromMap()
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
    
    // MARK: - BUILDING LIST delegate
    
    func dismissBySelect(building: Building) {
        self.dismiss(animated: true, completion: {
            self.addBuildingPin(building: building)
        })
    }
    
    func dismissBySelectFavorite(building annotation: BuildingPin) {
        self.dismiss(animated: true, completion: {
            self.setFavoriteBuildingsVisiable()
            self.mapView.setCenter(annotation.coordinate, animated: true)
        })
    }
    
    func dismissBySelectforDirection(building: Building, direction: Bool) {
    self.dismiss(animated: true, completion: {
        if (direction) {
            let buildingPin = self.addBuildingPinForNavigation(building: building, type: "destination")
            let toLocation = MKMapItem(placemark: MKPlacemark(coordinate: buildingPin.coordinate))
            if let fromLocation = self.selectedBuilding {
                self.calculateDirection(from: fromLocation, to: toLocation)
            }
        } else {
            let buildingPin = self.addBuildingPinForNavigation(building: building, type: "source")
            let fromLocation = MKMapItem(placemark: MKPlacemark(coordinate: buildingPin.coordinate))
            if let toLocation = self.selectedBuilding {
                self.calculateDirection(from: fromLocation, to: toLocation)
            }
        }
    })
    }
    
    func dismissBySelectMyLocationforDirection(direction: Bool) {
        self.dismiss(animated: true, completion: {
            if (direction) {
                let toLocation = MKMapItem.forCurrentLocation()
                if let fromLocation = self.selectedBuilding {
                    self.calculateDirection(from: fromLocation, to: toLocation)
                }
            } else {
                let fromLocation = MKMapItem.forCurrentLocation()
                if let toLocation = self.selectedBuilding {
                    self.calculateDirection(from: fromLocation, to: toLocation)
                }
            }
        })
    }
    
    func addBuildingPinForNavigation(building: Building, type: String) -> BuildingPin {
        let buildingNavigationAnnotation = BuildingPin(building: building, isFavorite: false)
        buildingNavigationAnnotation.isNavigation = true
        switch type {
        case "destination":
            buildingNavigationAnnotation.isDestination = true
        case "source":
            buildingNavigationAnnotation.isSource = true
        default:
            assert(false, "Unhandled Condition")
        }
        
        self.mapView.addAnnotation(buildingNavigationAnnotation)
        
        let delta = 0.01
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: buildingNavigationAnnotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        return buildingNavigationAnnotation
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
            let buildingVC = nav.topViewController as! BuildingViewController
            buildingVC.favoriteBuildingAnnotations = self.favoriteBuildingAnnotations
            buildingVC.delegate = self
        case "pickLocation":
            let nav = segue.destination as! UINavigationController
            let buildingVC = nav.topViewController as! BuildingViewController
            buildingVC.favoriteBuildingAnnotations = self.favoriteBuildingAnnotations
            buildingVC.delegate = self
            buildingVC.direction = self.direction
            buildingVC.selectedBuilding = self.selectedBuilding
            buildingVC.showUserLocation = true
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
            if (buildingAnnotation.isDestination) {
                annotationView.pinTintColor = .green
            } else if (buildingAnnotation.isSource) {
                annotationView.pinTintColor = .yellow
            }
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
        //add button hidden status change
        self.toggleFavoriteBuildingsButton.isHidden = false
        self.mapView.addAnnotation(annotation)
    }
    
    func removeFromFavorite(annotation: BuildingPin) {
        self.mapView.removeAnnotation(annotation)
        if let indexToRemove = self.favoriteBuildingAnnotations.firstIndex(where: { $0 == annotation }) {
            self.favoriteBuildingAnnotations.remove(at: indexToRemove)
            if (self.favoriteBuildingAnnotations.count == 0) {
                //add button hidden status change
                self.toggleFavoriteBuildingsButton.isHidden = true
            }
            annotation.isFavorite = false
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func calculateDirection(from: MKMapItem, to: MKMapItem) {
        self.getDirections(from: from, to: to) { (response) in
            guard(response != nil) else { return }
            
            if let route = response?.routes.first {
                let coordinates = route.polyline.coordinates
                let directionPolyline = DirectionPolyline(coordinates: coordinates, count: coordinates.count)
                self.mapView.addOverlay(directionPolyline)
                self.clearDirectionButton.isHidden = false
            }

        }
    }
    
    
    
    func getDirections(from: MKMapItem, to: MKMapItem, completion: @escaping(MKDirections.Response?)->()) {
        let request = MKDirections.Request()
        request.source = from
        request.destination = to
        
        let directions = MKDirections.init(request: request)
        directions.calculate { (response, err) in
            guard(err == nil) else { print(err!.localizedDescription);return }
            completion(response)
        }
    }
    
    
    func deletePin(annotation: MKAnnotation) {
        self.mapView.removeAnnotation(annotation)
        if (annotation is BuildingPin && (annotation as! BuildingPin).isFavorite) {
            self.removeFromFavorite(annotation: annotation as! BuildingPin)
        }
    }
    
    @objc func displayActionSheet(_ sender: Any) {
        
        if let annotation = self.mapView.selectedAnnotations.first {
            if (annotation is BuildingPin) {
                let buildingAnnotation = annotation as! BuildingPin
                var favoriteAction: UIAlertAction = UIAlertAction(title: "Add Favorite", style: .default) { (UIAlertAction) in
                    self.addToFavorite(annotation: annotation as! BuildingPin)
                }
                if buildingAnnotation.isFavorite {
                    favoriteAction = UIAlertAction(title: "Remove Favorite", style: .default) { (UIAlertAction) in
                        let BuildingAnnotation = annotation as! BuildingPin
                        self.removeFromFavorite(annotation: BuildingAnnotation)
                    }
                }
                let optionMenu = UIAlertController(title: annotation.title!, message: "Choose Option", preferredStyle: .actionSheet)
                    
                 let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
                    self.deletePin(annotation: annotation)
                }
                
                let directionFromAction: UIAlertAction = UIAlertAction(title: "Direction from", style: .default) { (UIAlertAction) in
                    self.clearNavigation()
                    self.direction = false // backward direction
                    self.setDestination(for: buildingAnnotation)
                    self.selectedBuilding = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
                    self.showLocationsForSelect()
                }
                
                let directionToAction: UIAlertAction = UIAlertAction(title: "Direction to", style: .default) { (UIAlertAction) in
                    self.clearNavigation()
                    self.direction = true // forward direction
                    self.setSource(for: buildingAnnotation)
                    self.selectedBuilding = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
                    self.showLocationsForSelect()
                }
                
                let showDetailAction: UIAlertAction = UIAlertAction(title: "Details", style: .default) { (UIAlertAction) in
    //                self.showLocationsForSelect()
                }
                    
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                optionMenu.addAction(deleteAction)
                optionMenu.addAction(favoriteAction)
                optionMenu.addAction(directionFromAction)
                optionMenu.addAction(directionToAction)
                optionMenu.addAction(showDetailAction)
                optionMenu.addAction(cancelAction)

                self.present(optionMenu, animated: true, completion: nil)
            }
        }

    }
    
    func clearNavigation() {
        self.mapView.removeAnnotations(self.mapView.annotations.filter({ (annotation) -> Bool in
            if (annotation is BuildingPin) {
                let BAnnotation = annotation as! BuildingPin
                return BAnnotation.isNavigation
            } else {
                return true
            }
        }))
        
        let directionsOverlayToRemove = self.mapView.overlays.filter({(overlay) -> Bool in
            if overlay is DirectionPolyline {
                return true
            } else {
                return false
            }
        })
        
        self.mapView.removeOverlays(directionsOverlayToRemove)
    }
    
    func setSource(for pin: BuildingPin) {
        let sourcePin = pin
        sourcePin.isNavigation = true
        sourcePin.isSource = true
        mapView.removeAnnotation(pin)
        mapView.addAnnotation(sourcePin)
    }
    
    func setDestination(for pin: BuildingPin) {
        let destinationPin = pin
        destinationPin.isNavigation = true
        destinationPin.isDestination = true
        mapView.removeAnnotation(pin)
        mapView.addAnnotation(destinationPin)
    }
    
    func showLocationsForSelect() {
        self.performSegue(withIdentifier: "pickLocation", sender: self)
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
//        print(mode)
//        if mode == .none {
//            self.mapView.showsUserLocation = false
//        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

      if overlay is DirectionPolyline {
        let directionOverlay = overlay as! DirectionPolyline
        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = directionOverlay.color
        lineView.lineWidth = 4
        return lineView
      }
        
      return MKOverlayRenderer()
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

