//
//  StateParksCollectionViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/5/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class StateParksCollectionViewController: UICollectionViewController {
    let parkModel = ParksModel.shared
    var imageZoomScrollView: UIScrollView?
    var identityFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.parkCount
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return parkModel.ParkImageCount(forSection: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stateParkCollectionCell", for: indexPath) as! StateParkCollectionViewCell
        let parkPhoto = parkModel.parkPhotoForIndexPath(indexPath: indexPath)

        let image = UIImage(named: parkPhoto.imageName)
        cell.parkImage.image = image
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "stateParkCollectionSectionHeader", for: indexPath)
            
            let parkTitle = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 44.0))
            parkTitle.textAlignment = .center
            parkTitle.backgroundColor = .black
            parkTitle.textColor = .white
            parkTitle.text = parkModel.ParkName(forSection: indexPath.section)
            headerView.backgroundColor = UIColor.black
            
            headerView.addSubview(parkTitle)
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            assert(false, "Unexpected element kind")
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionCell = self.collectionView.cellForItem(at: indexPath) as! StateParkCollectionViewCell
        let imageView = collectionCell.parkImage
        
        let frame = collectionCell.convert(imageView!.frame, to: self.view)
        
        self.imageZoomScrollView = UIScrollView(frame: frame)
        self.identityFrame = frame
        self.imageZoomScrollView?.delegate = self
        self.imageZoomScrollView?.minimumZoomScale = 1.0
        self.imageZoomScrollView?.maximumZoomScale = 10.0
        self.view.addSubview(self.imageZoomScrollView!)
        
        let copyImageView = UIImageView(image: imageView!.image)
        copyImageView.frame = collectionCell.convert(imageView!.frame, to: self.imageZoomScrollView!)
        self.imageZoomScrollView!.addSubview(copyImageView)
        
        copyImageView.backgroundColor = .clear
        copyImageView.contentMode = .scaleAspectFit
        copyImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        copyImageView.addGestureRecognizer(tap)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.collectionView.isScrollEnabled = false
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.imageZoomScrollView!.frame = UIScreen.main.bounds
//            self.imageZoomScrollView!.frame = self.imageZoomScrollView!.frame.offsetBy(dx: 0, dy: self.collectionView.contentOffset.y)
            self.imageZoomScrollView!.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageZoomScrollView!.backgroundColor = .white
            
            copyImageView.frame = UIScreen.main.bounds
            copyImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            copyImageView.backgroundColor = .white
        }, completion: { finished in
            self.imageZoomScrollView?.zoomScale = 1.0
        })
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        if (self.imageZoomScrollView?.zoomScale == 1.0) {
            let imageView = sender.view as! UIImageView
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.collectionView.isScrollEnabled = true
            self.imageZoomScrollView!.backgroundColor = .clear
            imageView.backgroundColor = .clear

            imageView.frame = self.imageZoomScrollView!.convert(imageView.frame, to: self.collectionView)
            self.collectionView.addSubview(imageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.imageZoomScrollView!.frame = self.identityFrame!
                imageView.frame = self.view.convert(self.identityFrame!, to: self.collectionView)

                //            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { finished in
                sender.view?.removeFromSuperview()
                self.imageZoomScrollView?.removeFromSuperview()
                self.imageZoomScrollView = nil
            })
        }
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.imageZoomScrollView! {
            return self.imageZoomScrollView!.subviews.first
        } else {
            return nil
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
