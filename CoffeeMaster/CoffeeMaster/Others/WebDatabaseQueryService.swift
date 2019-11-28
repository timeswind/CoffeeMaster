//
//  WebDatabaseQueryService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

class WebDatabaseQueryService {
    var db: Firestore!
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        self.decoder = decoder
    }
    
    func uploadMedia(image: Data, folder: String, extention: String, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(folder)/\(UUID.init().uuidString)\(extention)")
        storageRef.putData(image, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }
}
