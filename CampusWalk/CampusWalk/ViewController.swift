//
//  ViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, BuildingTableViewControllerDelegate {

    let mapModel = MapModel.shared
    
    @IBOutlet weak var showListButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let delta = 0.014
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: mapModel.center, span: span)
        mapView.setRegion(region, animated: true)
        
    }

    func dismissed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissBySelect(building: Building) {
        self.dismissed()
        print(building)
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

}

