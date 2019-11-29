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
import CodableFirebase

struct Post:Codable, Identifiable {
    var id: String?
    var title: String
    var body: String
    var created_at: Timestamp?
    var updated_at: Timestamp?
    var created_by_uid: String
    var allow_comment: Bool?
    var likes: Int?
    
    var brewGuide: BrewGuide?
    var record: Record?
    
    var images_url: [String]?
    
    // not include in coding and decoding
    var images: [Data] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case created_at
        case updated_at
        case created_by_uid
        case allow_comment
        case likes
        case brewGuide
        case record
        case images_url
    }
    
    init(title: String, body: String, created_by_uid: String, allow_comment: Bool) {
        self.title = title
        self.body = body
        self.created_by_uid = created_by_uid
        self.allow_comment = allow_comment
    }
}

struct Comment:Codable, Identifiable {
    var id: String?
    var body: String
    var created_at: Timestamp?
    var created_by_uid: String
    var likes: Int
    var post_id: String!
}

//func convertTimestamp(serverTimestamp: Double) -> String {
//    let x = serverTimestamp / 1000
//    let date = NSDate(timeIntervalSince1970: x)
//    let formatter = DateFormatter()
//    formatter.dateStyle = .long
//    formatter.timeStyle = .medium
//
//    return formatter.string(from: date as Date)
//}
