//
//  Record.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

 struct Record:Codable, Identifiable {
    var id: String?
    var title: String
    var body: String
    var created_at: Timestamp?
    var created_by_uid: String
    var images_path: [String]?
    var tags: [String]?
    
    init(title: String, body: String, created_by_uid: String) {
        self.title = title
        self.body = body
        self.created_by_uid = created_by_uid
    }
}
