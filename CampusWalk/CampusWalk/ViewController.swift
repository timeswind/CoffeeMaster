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


class ViewController: UIViewController, MKMapViewDelegate, BuildingTableViewControllerDelegate {

    let mapModel = MapModel.shared
    
    @IBOutlet weak var showListButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        let delta = 0.014
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: mapModel.center, span: span)
        mapView.setRegion(region, animated: true)
        
    }

    func dismissed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissBySelect(building: Building) {
        self.dismiss(animated: true, completion: {
            self.addBuildingPin(building: building)
        })
    }
    
    func addBuildingPin(building: Building) {
        print(building)
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
    
    func deletePin(annotation: MKAnnotation) {
        self.mapView.removeAnnotation(annotation)
    }
    
    @objc func displayActionSheet(_ sender: Any) {
        if let annotation = self.mapView.selectedAnnotations.first {
            var favoriteAction: UIAlertAction = UIAlertAction(title: "Add Favorite", style: .default)
            
            if (annotation is BuildingPin) {
                let buildingAnnotation = annotation as! BuildingPin
                if buildingAnnotation.isFavorite {
                    favoriteAction = UIAlertAction(title: "Remove Favorite", style: .default)
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

}

