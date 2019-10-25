//
//  BuildingTableViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

protocol BuildingViewControllerDelegate:class {
    func dismissed()
    func dismissBySelect(building:Building)
    func dismissBySelectFavorite(building annotation:BuildingPin)
}

class BuildingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    var delegate:BuildingViewControllerDelegate?
    var favoriteBuildingAnnotations: [BuildingPin] = []
    let mapModel = MapModel.shared
    
    var showUserLocation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.segmentControl.addTarget(self, action: #selector(segmentOnTouch), for: .valueChanged)
        
    }
    
    @objc func segmentOnTouch() {
        self.myTableView.reloadData()
    }

    @objc func close() {
        self.delegate?.dismissed()
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            if (showUserLocation) {
                return mapModel.buildingDic.count + 1
            } else {
                return mapModel.buildingDic.count
            }
        case 1:
            if (showUserLocation) {
                return 2
            } else {
                return 1
            }
        default:
            return mapModel.buildingDic.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentControl.selectedSegmentIndex {
        case 1:
            if (showUserLocation) {
                if (section == 0) {
                    return 1;
                } else {
                    return self.favoriteBuildingAnnotations.count
                }
            } else {
                return self.favoriteBuildingAnnotations.count
            }
        default:
            if (showUserLocation) {
                if (section == 0) {
                    return 1;
                } else {
                    let key = mapModel.buildingKeys[section - 1]
                    if let buildings = mapModel.buildingDic[key] {
                        return buildings.count
                    }
                        
                    return 0
                    
                }
            } else {
                let key = mapModel.buildingKeys[section]
                if let buildings = mapModel.buildingDic[key] {
                    return buildings.count
                }
                    
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildingsCell", for: indexPath) as! BuildingTableViewCell

        switch self.segmentControl.selectedSegmentIndex {
        case 1:
            if (showUserLocation) {
                if (indexPath.section == 0) {
                    cell.name.text = "My Current Location"
                    return cell
                } else {
                    let buildingName = self.favoriteBuildingAnnotations[indexPath.row].title
                    cell.name.text = buildingName
                    return cell
                }
            } else {
                let buildingName = self.favoriteBuildingAnnotations[indexPath.row].title
                cell.name.text = buildingName
                return cell
            }
        default:
            if (showUserLocation) {
                if (indexPath.section == 0) {
                    cell.name.text = "My Current Location"
                    return cell
                } else {
                    let key = mapModel.buildingKeys[indexPath.section - 1]
                    if let buildings = mapModel.buildingDic[key] {
                        let building = buildings[indexPath.row]
                        cell.name.text = building.name
                    }

                    return cell
                }
            } else {
                let key = mapModel.buildingKeys[indexPath.section]
                if let buildings = mapModel.buildingDic[key] {
                    let building = buildings[indexPath.row]
                    cell.name.text = building.name
                }

                return cell
            }
        }
          

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.segmentControl.selectedSegmentIndex {
        case 1:
            if (showUserLocation) {
                if (section == 0) {
                    return "Location"
                } else {
                    return "Saved Favorite Buildings"
                }
            } else {
                return "Saved Favorite Buildings"
            }
        default:
            if (showUserLocation) {
                if (section == 0) {
                    return "Location"
                } else {
                    return mapModel.buildingKeys[section - 1]
                }
            } else {
                return mapModel.buildingKeys[section]
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        switch self.segmentControl.selectedSegmentIndex {
        case 1:
            return []
        default:
            if (showUserLocation) {
                var keys: [String] = [String]()
                keys.append("_")
                keys.append(contentsOf: mapModel.buildingKeys)
                return keys
            } else {
                return mapModel.buildingKeys
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.segmentControl.selectedSegmentIndex {
        case 1:
            self.delegate?.dismissBySelectFavorite(building: self.favoriteBuildingAnnotations[indexPath.row])
        default:
            let key = mapModel.buildingKeys[indexPath.section]
            if let buildings = mapModel.buildingDic[key] {
                let building = buildings[indexPath.row]
                self.delegate?.dismissBySelect(building: building)
            }
        }

    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
