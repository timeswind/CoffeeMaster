//
//  Dependencies.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/7/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import HealthKit

struct Dependencies {
    var webDatabaseQueryService: WebDatabaseQueryService
    var permissionRequestService: PermissionRequestService
    var requiredHeathKitTypes = Set([HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)])
    var staticDataService: StaticDataService
}

let dependencies =
    Dependencies(webDatabaseQueryService: WebDatabaseQueryService(),
                                permissionRequestService: PermissionRequestService(),
                                staticDataService: StaticDataService())

