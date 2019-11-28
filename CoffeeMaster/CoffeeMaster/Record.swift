//
//  Record.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/18/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Record:Codable, Identifiable {
    var id: String?
    var title: String
    var body: String
    var created_at: Timestamp?
    var updated_at: Timestamp?
    var created_by_uid: String
    var images_url: [String]?
    var tags: [String]?
    
    // not include in coding and decoding
    var images: [Data] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case created_at
        case updated_at
        case created_by_uid
        case images_url
        case tags
    }
    
    init(title: String, body: String, created_by_uid: String) {
        self.title = title
        self.body = body
        self.created_by_uid = created_by_uid
    }
}
