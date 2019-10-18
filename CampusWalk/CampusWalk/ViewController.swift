//
//  ViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    let mapModel = MapModel.shared
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let delta = 0.014
        let span = MKCoordinateSpan.init(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: mapModel.center, span: span)
        mapView.setRegion(region, animated: true)
        
    }


}

