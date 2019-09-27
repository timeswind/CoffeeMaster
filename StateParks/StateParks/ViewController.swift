//
//  ViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 9/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var MasterScrollView: UIScrollView!
    
    var articleScrollViews = [UIScrollView]()
    
    let parksModel = ParksModel()
    
    var currentArticlePage = 0
    var currentSectionPage = 0
    
    
    var articleImageViews = [Int: SectionImageViews]()
    typealias SectionImageViews = [Int: UIView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MasterScrollView.delegate = self
        configScrollViews()
    }
    
    func configScrollViews() {
        for _ in parksModel.allParkNames {
            let articleScrollView = UIScrollView(frame: CGRect.zero)
            MasterScrollView.addSubview(articleScrollView)
            MasterScrollView.isPagingEnabled = true
            articleScrollView.isPagingEnabled = true
            articleScrollViews.append(articleScrollView)
        }
    }

    override func viewDidLayoutSubviews() {
        let size = self.MasterScrollView.bounds.size

        MasterScrollView.contentSize = CGSize(width: size.width * CGFloat(parksModel.parkCount), height: size.height)
        MasterScrollView.contentOffset = CGPoint(x: CGFloat(self.currentArticlePage) * size.width, y: 0.0)

        for (index, name) in parksModel.allParkNames.enumerated() {
            let articleScrollView = articleScrollViews[index]
            let frame = CGRect(origin: CGPoint(x: CGFloat(index) * size.width, y: 0.0), size: size)
            articleScrollView.frame = frame
//            articleScrollView.backgroundColor = UIColor.random()
            let parkImageCount = parksModel.ParkImageCount(forPark: name)
            for subviews in articleScrollView.subviews {
                subviews.removeFromSuperview()
            }
            setUpArticleScrollView(for: articleScrollView, parkName: name, imageCount: parkImageCount, page: index)
        }
        articleScrollViews[currentArticlePage].contentOffset = CGPoint(x: 0.0, y: CGFloat(self.currentSectionPage) * size.height)
        articleScrollViews[currentArticlePage].delegate = self
    }
    
    func setUpArticleScrollView(for articleScrollView: UIScrollView, parkName: String, imageCount: Int, page: Int) {
            for view in articleScrollView.subviews {
                view.removeFromSuperview()
            }
            articleScrollView.minimumZoomScale = 1
            articleScrollView.maximumZoomScale = 10
        
            let size = articleScrollView.bounds.size
            let maxImageWidth = articleScrollView.bounds.size.width
            let maxImageHeight = articleScrollView.bounds.size.height
            let halfHeight = size.height / 2
        
            articleScrollView.contentSize = CGSize(width: size.width, height: size.height * CGFloat(imageCount))
            var sectionImageViews: SectionImageViews = [Int: UIImageView]()
            for i in 0..<imageCount {
                let image = UIImage(named: "\(parkName)0\(i + 1)")
                let imageContainerView = UIView(frame: CGRect.zero)
                let parkImageView = UIImageView(image: image)
                
                var ratio = maxImageWidth / parkImageView.frame.width
                
                if (ratio *  parkImageView.frame.height > maxImageHeight) {
                    ratio = maxImageHeight / parkImageView.frame.height
                }
                parkImageView.frame.size = CGSize(width: ratio *  parkImageView.frame.width, height: ratio *  parkImageView.frame.height)
                
                let imageContainerFrame = CGRect(origin: CGPoint(x: 0.0, y: CGFloat(i) * size.height), size: size)
                imageContainerView.frame = imageContainerFrame
                imageContainerView.addSubview(parkImageView)
                sectionImageViews.updateValue(imageContainerView, forKey: i)
                parkImageView.center = CGPoint(x: imageContainerView.center.x, y: parkImageView.center.y - (parkImageView.frame.height / 2) + halfHeight)
                articleScrollView.addSubview(imageContainerView)
                let parkTitle = UILabel(frame: CGRect(x: 22, y: 44, width: size.width - 88, height: 88))
                let font = UIFont.systemFont(ofSize: 35, weight: .bold)
                parkTitle.text = parkName
                parkTitle.font = font
                articleScrollView.addSubview(parkTitle)
            }
        
        articleScrollView.showsVerticalScrollIndicator = false
        articleScrollView.showsVerticalScrollIndicator = true
        articleImageViews.updateValue(sectionImageViews, forKey: page)
//        self.view.setNeedsLayout()
//            let parkTitle = UILabel(frame: CGRect.zero)
//            parkTitle.text = parkName
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let size = self.MasterScrollView.bounds.size

        if scrollView == self.MasterScrollView {
            let articlePage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
            articleScrollViews[articlePage].delegate = self
            self.currentArticlePage = articlePage
        } else {
            let sectionPage = Int(scrollView.contentOffset.y / scrollView.bounds.size.height)
            self.currentSectionPage = sectionPage
            
            if (currentSectionPage != 0) {
                MasterScrollView.contentSize = CGSize(width: size.width, height: size.height)
                MasterScrollView.contentOffset = CGPoint(x: CGFloat(self.currentArticlePage) * size.width, y: 0.0)

            } else {
                MasterScrollView.contentSize = CGSize(width: size.width * CGFloat(parksModel.parkCount), height: size.height)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return articleImageViews[currentArticlePage]![currentSectionPage]
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        for theView in scrollView.subviews {
            if theView != view {
                theView.isHidden = true
            }
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if (scale == CGFloat(1)) {
            self.setUpArticleScrollView(for: scrollView, parkName: parksModel.allParkNames[currentArticlePage], imageCount: parksModel.ParkImageCount(forPark: parksModel.allParkNames[currentArticlePage]), page:currentArticlePage)
            for theView in scrollView.subviews {
                theView.isHidden = false
            }
        }
    }

}

