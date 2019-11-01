//
//  BuildingDetailViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 11/1/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class BuildingDetailViewController: UIViewController {
    
    var scrollView:UIScrollView!
    var building: Building!
    var customizeImage: UIImage?
    var buildingDetail: BuildingDetail!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        let size = self.view.bounds.size
        let buildingNameLabelFrame = CGRect(x: 20, y: 20, width: 200, height: 20)
        let buildingNameLabel = UILabel(frame: buildingNameLabelFrame)
        buildingNameLabel.text = self.building.name
        
        
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.addSubview(buildingNameLabel)
        self.view.addSubview(scrollView)
    }
    
    func initialize(building: Building, buildingDetail: BuildingDetail) {
        self.building = building
        self.buildingDetail = buildingDetail
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
