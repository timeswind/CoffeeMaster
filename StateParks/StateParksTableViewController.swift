//
//  StateParksTableViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/5/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class StateParksTableViewController: UITableViewController {
    
    let parkModel = ParksModel.shared
    var imageZoomScrollView: UIScrollView?
    var identityFrame:CGRect?
    var isSectionExpended:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        for _ in 0...(parkModel.parkCount - 1 ){
            isSectionExpended.append(true)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func viewDidLayoutSubviews() {
        if let imageZoomView = self.imageZoomScrollView {
            imageZoomView.frame = UIScreen.main.bounds
            if let image = imageZoomView.subviews.first {
                image.frame = UIScreen.main.bounds
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.parkCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isSectionExpended[section] ? parkModel.ParkImageCount(forSection: section) : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateParkTableCell", for: indexPath) as! StateParkTableViewCell
        let parkPhoto = parkModel.parkPhotoForIndexPath(indexPath: indexPath)
        cell.captionLabel?.text = parkPhoto.caption
        
        let image = UIImage(named: parkPhoto.imageName)
        cell.parkImageView.image = image

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleHeaderOnTap(_:)))
        let parkTitle = UILabel(frame: CGRect.zero)
        parkTitle.tag = section
        parkTitle.isUserInteractionEnabled = true
        parkTitle.addGestureRecognizer(tap)

        parkTitle.textAlignment = .center
        parkTitle.backgroundColor = .black
        parkTitle.textColor = .white
        parkTitle.text = parkModel.ParkName(forSection: section)
        
        return parkTitle
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableCell = self.tableView.cellForRow(at: indexPath) as! StateParkTableViewCell
        let imageView = tableCell.parkImageView
        
        let frame = tableCell.convert(imageView!.frame, to: self.view)
        
        self.imageZoomScrollView = UIScrollView(frame: frame)
        self.identityFrame = frame
        self.imageZoomScrollView?.delegate = self
        self.imageZoomScrollView?.minimumZoomScale = 1.0
        self.imageZoomScrollView?.maximumZoomScale = 10.0
        
        self.view.addSubview(self.imageZoomScrollView!)
    
        let copyImageView = UIImageView(image: imageView!.image)
        copyImageView.frame = tableCell.convert(imageView!.frame, to: self.imageZoomScrollView!)
        self.imageZoomScrollView!.addSubview(copyImageView)
        
        copyImageView.backgroundColor = .clear
        copyImageView.contentMode = .scaleAspectFit
        copyImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        copyImageView.addGestureRecognizer(tap)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.isScrollEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.imageZoomScrollView!.frame = UIScreen.main.bounds
            self.imageZoomScrollView!.frame = self.imageZoomScrollView!.frame.offsetBy(dx: 0, dy: self.tableView.contentOffset.y)
            self.imageZoomScrollView!.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageZoomScrollView!.backgroundColor = .white

            copyImageView.frame = UIScreen.main.bounds
            copyImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            copyImageView.backgroundColor = .white
        }, completion: { finished in
            self.imageZoomScrollView?.zoomScale = 1.0
        })
    }
    
    @objc func handleHeaderOnTap(_ sender: UITapGestureRecognizer) {
        let header = sender.view as! UILabel
        let section = header.tag
        self.isSectionExpended[section] = !self.isSectionExpended[section]
        self.tableView.reloadSections([section], with: UITableView.RowAnimation.automatic)
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        if (self.imageZoomScrollView?.zoomScale == 1.0) {
            let imageView = sender.view as! UIImageView
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.tableView.isScrollEnabled = true
            
            imageView.frame = self.imageZoomScrollView!.convert(imageView.frame, to: self.tableView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.imageZoomScrollView!.frame = self.identityFrame!
                imageView.frame = self.view.convert(self.identityFrame!, to: self.tableView)
                self.tableView.addSubview(imageView)
                //            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                imageView.backgroundColor = .clear
                self.imageZoomScrollView!.backgroundColor = .clear
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
