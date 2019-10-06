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
    var capition: [String]
}

//typealias Parks = [Park]
typealias StateParks = [StatePark]


class ParksModel {
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
            return allParks.map({(park:StatePark) in
                return park.name
            })
        }
    }
    
    var parkCount:Int {
        get {
            return allParks.count
        }
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
