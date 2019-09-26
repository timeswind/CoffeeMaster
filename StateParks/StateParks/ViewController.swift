//
//  ViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 9/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MasterScrollView: UIScrollView!
    
    var articleScrollViews = [UIScrollView]()
    
    let parksModel = ParksModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in parksModel.allParkNames {
            let articleScrollView = UIScrollView(frame: CGRect.zero)
//            let parkTitle = UILabel(frame: CGRect.zero)
//            parkTitle.text = parkName
//            articleScrollView.addSubview(parkTitle)
            MasterScrollView.addSubview(articleScrollView)
            MasterScrollView.isPagingEnabled = true
            articleScrollView.isPagingEnabled = true
            articleScrollViews.append(articleScrollView)
        }
//        print(parksModel.allParkNames)
//        print(parksModel.ParkImageCount(forPark: parksModel.allParkNames[0]))
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        let size = self.MasterScrollView.bounds.size
        
        MasterScrollView.contentSize = CGSize(width: size.width * CGFloat(parksModel.parkCount), height: size.height)
        for (index, name) in parksModel.allParkNames.enumerated() {
            let articleScrollView = articleScrollViews[index]
            let frame = CGRect(origin: CGPoint(x: CGFloat(index) * size.width, y: 0.0), size: size)
            articleScrollView.frame = frame
            articleScrollView.backgroundColor = UIColor.random()
            let parkImageCount = parksModel.ParkImageCount(forPark: name)
            setUpArticleScrollView(for: articleScrollView, parkName: name, imageCount: parkImageCount)
        }
    }
    
    func setUpArticleScrollView(for articleScrollView: UIScrollView, parkName: String, imageCount: Int) {
            let size = articleScrollView.bounds.size
            articleScrollView.contentSize = CGSize(width: size.width, height: size.height * CGFloat(imageCount))
            for i in 0..<imageCount {
                let image = UIImage(named: "\(parkName)0\(i)")
                let parkImageView = UIImageView(image: image)
                let frame = CGRect(origin: CGPoint(x: 0.0, y: CGFloat(i) * size.height), size: size)
                print(CGFloat(i) * size.height)
                articleScrollView.addSubview(parkImageView)
                articleScrollView.bringSubviewToFront(parkImageView)
                parkImageView.frame = frame
            }
//            let parkTitle = UILabel(frame: CGRect.zero)
//            parkTitle.text = parkName
    }

}

