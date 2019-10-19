//
//  MapModel.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import MapKit

struct Building:Codable {
    var name: String
    var opp_bldg_code: Int
    var year_constructed: Int
    var latitude: Float64
    var longitude: Float64
    var photo: String
}

typealias Buildings = [Building]

class MapModel {
    static let shared = MapModel()
    
    var allBuildings: Buildings
    var buildingDic: [String:Buildings] = [String:Buildings]()
    var buildingKeys: [String] = [String]()

    let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7964727, longitude: -77.865005)
        
    init() {
        let mainBundle = Bundle.main
        let buildingsListURL = mainBundle.url(forResource: "buildings", withExtension: "plist")
        do {
            let data = try Data(contentsOf: buildingsListURL!)
            let decoder = PropertyListDecoder()
            allBuildings = try decoder.decode(Buildings.self, from: data)
            // sort by name field letter
            allBuildings = allBuildings.sorted { $0.name < $1.name }
        } catch {
            print(error)
            allBuildings = []
        }
        extractIndex()
    }
    
    func extractIndex() {
        let buildings = self.allBuildings
        for building in buildings {
            let buildingKey = String(building.name.prefix(1))
                if let _ = buildingDic[buildingKey] {
                    buildingDic[buildingKey]!.append(building)
                } else {
                    buildingDic[buildingKey] = [building]
                    buildingKeys.append(buildingKey)
                }
        }
    }
    
    
    
}