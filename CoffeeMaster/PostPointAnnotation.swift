//
//  PostPointAnnotation.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/12/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Mapbox

class PostPointAnnotation: MGLPointAnnotation {
    var post: Post!
    var image: UIImage?
    var reuseIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, post: Post) {
        super.init()
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.post = post
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
