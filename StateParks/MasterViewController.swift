//
//  MasterViewController.swift
//  MasterDetail
//
//  Created by Mingtian Yang on 10/12/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    let parkModel = ParksModel.shared
    let instructionModel = InstructionModel.shared

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var isSectionExpended:[Bool] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "State Parks"
        for _ in 0...(parkModel.parkCount - 1 ){
            isSectionExpended.append(true)
        }
        
        // Do any additional setup after loading the view.
        firstTimeLaunch()
                
        if let split = splitViewController {
            split.preferredDisplayMode = .allVisible
//            split.delegate = self
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Functions
    
    func firstTimeLaunch() {
        print(instructionModel.instructions)
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            self.performSegue(withIdentifier: "showInstruction", sender: self)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = (tableView.cellForRow(at: indexPath) as! StateParkTableViewCell)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.parkCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isSectionExpended[section] ? parkModel.ParkImageCount(forSection: section) : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StateParkTableViewCell
        let parkPhoto = parkModel.parkPhotoForIndexPath(indexPath: indexPath)
        cell.captionLabel?.text = parkPhoto.caption
        
        let image = UIImage(named: parkPhoto.imageName)
        cell.parkImageView.image = image
        
        // Configure the cell...
        
        return cell
    }
    
    @objc func handleHeaderOnTap(_ sender: UITapGestureRecognizer) {
        let header = sender.view as! UILabel
        let section = header.tag
        self.isSectionExpended[section] = !self.isSectionExpended[section]
        self.tableView.reloadSections([section], with: UITableView.RowAnimation.automatic)
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
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

