//
//  ParksModel.swift
//  StateParks
//
//  Created by Mingtian Yang on 9/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import UIKit

//struct Park : Codable {
//    var name : String
//    var count : Int
//}

//phase2
struct StatePark: Codable {
    var name: String
    var photos: [StateParkPhoto]
}

struct StateParkPhoto: Codable {
    var imageName: String
    var caption: String
}

//typealias Parks = [Park]
typealias StateParks = [StatePark]


class ParksModel {
    static let shared = ParksModel()
    
    let allParks: StateParks
    
    init() {
        let mainBundle = Bundle.main
        let parksListURL = mainBundle.url(forResource: "StateParks", withExtension: "plist")
        do {
            let data = try Data(contentsOf: parksListURL!)
            let decoder = PropertyListDecoder()
            allParks = try decoder.decode(StateParks.self, from: data)
        } catch {
            print(error)
            allParks = []
        }
    }
    
    var allParkNames:[String] {
        get {
            return allParks.map({(sp:StatePark) in
                return sp.name
            })
        }
    }
    
    func parkPhotoForIndexPath(indexPath: IndexPath) -> StateParkPhoto {
        let section = indexPath.section
        let row = indexPath.row
        return allParks[section].photos[row]
    }
    
    var parkCount:Int {
        get {
            return allParks.count
        }
    }
    
    func ParkName(forSection section: Int) -> String {
        return allParks[section].name
    }
    
    
    func ParkImageCount(forSection section: Int) -> Int {
        return allParks[section].photos.count
    }
    
    func ParkImageCount(forPark name: String) -> Int {
        for park in allParks {
            if (park.name == name) {
                return park.photos.count
            }
        }
        return 0
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
