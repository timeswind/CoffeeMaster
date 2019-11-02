//
//  MapModel.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import MapKit

struct Building:Codable, Hashable {
    var name: String
    var opp_bldg_code: Int
    var year_constructed: Int
    var latitude: Float64
    var longitude: Float64
    var photo: String
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.name == rhs.name && lhs.latitude == rhs.latitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(latitude)
    }
}

struct BuildingDetail {
    var description: String
    var customizeImage: UIImage?
}

typealias Buildings = [Building]

class MapModel {
    static let shared = MapModel()
    
    fileprivate var allBuildings: Buildings
    fileprivate var buildings: Buildings

    
    var buildingDic: [String:Buildings] = [String:Buildings]()
    var buildingKeys: [String] = [String]()
    var buildingDetailDic: [Building: BuildingDetail] = [Building: BuildingDetail]()

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
            buildings = self.allBuildings
        } catch {
            print(error)
            allBuildings = []
            buildings = []
        }
        extractIndex()
    }
    
    func extractIndex() {
        buildingKeys = [String]()
        buildingDic = [String:Buildings]()
        
        for building in self.buildings {
            let buildingKey = String(building.name.prefix(1))
                if let _ = buildingDic[buildingKey] {
                    buildingDic[buildingKey]!.append(building)
                } else {
                    buildingDic[buildingKey] = [building]
                    buildingKeys.append(buildingKey)
                }
        }
    }
    
    func updateFilter(filter:(Building) -> Bool) {
        buildings = allBuildings.filter(filter)
        self.extractIndex()
    }
    
    func resetFilter() {
        self.buildings = allBuildings
        self.extractIndex()
    }
    
    func buildingHasDeatil(building: Building) -> Bool {
        if let _ = self.buildingDetailDic[building] {
            return true
        }

        return false
    }
    
    func newBuildingDetail(building: Building) ->BuildingDetail {
        if (!self.buildingHasDeatil(building: building)) {
            let buildingDetail = BuildingDetail(description: "", customizeImage: nil)
            self.buildingDetailDic[building] = buildingDetail
            return buildingDetail
        } else {
            return self.buildingDetailDic[building]!
        }
    }
    
    func getBuildingDetail(building: Building)-> BuildingDetail {
        if (self.buildingHasDeatil(building: building)) {
            return self.buildingDetailDic[building]!
        } else {
            return self.newBuildingDetail(building: building)
        }
    }
    
    func updateBuildingDetail(building: Building, newBuildingDetail: BuildingDetail) {
        var buildingDetail = self.getBuildingDetail(building: building)
        buildingDetail.customizeImage = newBuildingDetail.customizeImage
        buildingDetail.description = newBuildingDetail.description
        self.buildingDetailDic[building] = buildingDetail
    }
}
