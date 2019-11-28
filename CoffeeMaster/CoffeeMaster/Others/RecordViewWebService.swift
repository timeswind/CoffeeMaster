//
//  RecordViewWebService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import UIKit
import Combine
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase
import FirebaseStorage

extension WebDatabaseQueryService {
    // record
    func getMyRecords(query: String) -> AnyPublisher<[Record], Error> {
        let recordsRef = db.collection("records")
        
        let subject = PassthroughSubject<[Record], Error>()
        
        recordsRef.whereField("created_by_uid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var records: [Record] = []
                for document in querySnapshot!.documents {
                    var record = try! FirestoreDecoder().decode(Record.self, from: document.data())
                    record.id = document.documentID
                    records.append(record)
                }
                subject.send(records)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func addRecord(record: Record)  -> AnyPublisher<Record?, Error> {
        if (record.images.count > 0) {
            // upload images
        }
        
        let recordsRef = db.collection("records")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<Record?, Error>()
        
        let docData = try! FirestoreEncoder().encode(record)
        
        newDocRef = recordsRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                var newrecord = record
                newrecord.id = newDocRef!.documentID
                subject.send(newrecord)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func uploadMedia(image: Data, folder: String, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(folder)/\(UUID.init().uuidString)")
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
