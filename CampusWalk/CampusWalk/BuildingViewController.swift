//
//  BuildingTableViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import MapKit

protocol BuildingViewControllerDelegate:class {
    func dismissed()
    func dismissBySelect(building:Building)
    func dismissBySelectFavorite(building annotation:BuildingPin)
    
    func dismissBySelectforDirection(building:Building, direction: Bool)
    func dismissBySelectMyLocationforDirection(direction: Bool)
}

class BuildingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    var delegate:BuildingViewControllerDelegate?
    var favoriteBuildingAnnotations: [BuildingPin] = []
    let mapModel = MapModel.shared
    
    var showUserLocation: Bool = false
    var direction:Bool = false
    var selectedBuilding:MKMapItem?

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setEditing(true, animated: true)
        // Do any additional setup after loading the view.
        
        myTableView.delegate = self
        myTableView.dataSource = self
        segmentControl.addTarget(self, action: #selector(segmentOnTouch), for: .valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.scopeButtonTitles = ["By Name", "By Year"]
        
        searchController.searchBar.showsCancelButton = true
         
        myTableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    //Mark: - Notification Handlers
    @objc func keyboardWillShow(notification:Notification) {
     
    }
    
    @objc func keyboardWillHide(notification:Notification) {

    }
    
    @objc func segmentOnTouch() {
        self.myTableView.reloadData()
        if (self.segmentControl.selectedSegmentIndex == 0) {
            myTableView.tableHeaderView = searchController.searchBar
        } else {
            myTableView.tableHeaderView = nil
        }
    }

    @objc func close() {
        self.delegate?.dismissed()
    }
    
     //MARK: UISearchBar Delegate
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        let topRow = IndexPath(row: 0, section: 0)
//        self.myTableView.scrollToRow(at: topRow, at: .top, animated: true)
        mapModel.resetFilter()
        self.myTableView.reloadData()
     }
    
    
     
     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchController.searchBar.showsScopeBar = true
     }
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         searchController.searchBar.showsScopeBar = false
     }
     
     func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if (selectedScope == 1) {
            self.searchController.searchBar.searchTextField.keyboardType = .numberPad
        } else if (selectedScope == 0) {
            self.searchController.searchBar.searchTextField.keyboardType = .default
        }
        
        self.searchController.searchBar.searchTextField.resignFirstResponder()
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
     }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (self.searchController.searchBar.selectedScopeButtonIndex == 0) {
            return true
        } else if (self.searchController.searchBar.selectedScopeButtonIndex == 1) {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: text)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
     
     //MARK: UISearchResultsUpdating
     func updateSearchResults(for searchController: UISearchController) {
         let text = searchController.searchBar.text!
         
         if !text.isEmpty {
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0) {
                let filter = {(building:Building) in building.name.contains(text)}
                mapModel.updateFilter(filter: filter)
            } else if (self.searchController.searchBar.selectedScopeButtonIndex == 1) {
                let filter = {(building:Building) in building.year_constructed == Int(text)}
                mapModel.updateFilter(filter: filter)
            }
            self.myTableView.reloadData()
         }
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
            if (showUserLocation) {
                if (indexPath.section == 0) {
                    self.delegate?.dismissBySelectMyLocationforDirection(direction: self.direction)
                } else {
                    let building = self.favoriteBuildingAnnotations[indexPath.row].building
                    self.delegate?.dismissBySelectforDirection(building: building!, direction: self.direction)
                }
            } else {
                self.delegate?.dismissBySelectFavorite(building: self.favoriteBuildingAnnotations[indexPath.row])
            }
        default:
            if (showUserLocation) {
                if (indexPath.section == 0) {
                    self.delegate?.dismissBySelectMyLocationforDirection(direction: self.direction)
                } else {
                    let key = mapModel.buildingKeys[indexPath.section - 1]
                    if let buildings = mapModel.buildingDic[key] {
                        let building = buildings[indexPath.row]
                        self.delegate?.dismissBySelectforDirection(building: building, direction: self.direction)
                    }
                }
            } else {
                let key = mapModel.buildingKeys[indexPath.section]
                if let buildings = mapModel.buildingDic[key] {
                    let building = buildings[indexPath.row]
                    self.delegate?.dismissBySelect(building: building)
                }
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
