//
//  DetailViewController.swift
//  MasterDetail
//
//  Created by Mingtian Yang on 10/12/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.captionLabel.text
                detailImage.image = detail.parkImageView.image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Park Detail"
        configureView()
    }
    
    var detailItem: StateParkTableViewCell? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
}

