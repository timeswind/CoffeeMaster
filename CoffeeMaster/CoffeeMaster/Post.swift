//
//  Post.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

 struct Post:Codable, Identifiable {
    var id: String?
    var title: String
    var body: String
    var created_at: Timestamp?
    var created_by_uid: String
    var allow_comment: Bool?
    var likes: Int?
    
    init(title: String, body: String, created_by_uid: String, allow_comment: Bool) {
        self.title = title
        self.body = body
        self.created_by_uid = created_by_uid
        self.allow_comment = allow_comment
    }
    
//    init(dictionary: [String: Any]) {
//        self.id = dictionary["id"] as? String ?? nil
//        self.title = dictionary["title"] as? String ?? ""
//        self.body = dictionary["body"] as? String ?? ""
//        self.created_at = (dictionary["created_at"] as? Timestamp)?.dateValue() ?? Date()
//        self.created_by_uid = dictionary["created_by_uid"] as? String ?? ""
//        self.allow_comment = dictionary["allow_comment"] as? Bool ?? true
//        self.likes = dictionary["likes"] as? Int ?? 0
//    }
}

struct Comment:Codable, Identifiable {
    var id: String
    var body: String
    var created_at: Date
    var created_by_uid: String
    var likes: Int
    var post_id: String
}

func convertTimestamp(serverTimestamp: Double) -> String {
    let x = serverTimestamp / 1000
    let date = NSDate(timeIntervalSince1970: x)
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium

    return formatter.string(from: date as Date)
}
