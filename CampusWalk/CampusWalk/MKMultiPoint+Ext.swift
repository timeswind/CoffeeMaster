//
//  MKMultiPoint+Ext.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 10/28/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import MapKit

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}
