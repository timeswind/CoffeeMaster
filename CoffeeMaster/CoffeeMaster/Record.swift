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

 struct Record:Decodable, Identifiable {
    var id: String?
    var title: String
    var body: String
    var created_at: Date?
    var created_by_uid: String
    var images_path: [String]?
    var tags: [String]?
    
    init(title: String, body: String, created_by_uid: String) {
        self.title = title
        self.body = body
        self.created_by_uid = created_by_uid
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? nil
        self.title = dictionary["title"] as? String ?? ""
        self.body = dictionary["body"] as? String ?? ""
        self.created_at = (dictionary["created_at"] as? Timestamp)?.dateValue() ?? Date()
        self.created_by_uid = dictionary["created_by_uid"] as? String ?? ""
        self.images_path = dictionary["images_path"] as? [String] ?? []
        self.tags = dictionary["tags"] as? [String] ?? []
    }
}
