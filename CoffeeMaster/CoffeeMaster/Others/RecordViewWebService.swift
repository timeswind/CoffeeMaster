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

extension WebDatabaseQueryService {
    // record
    func getMyRecords(query: String) -> AnyPublisher<[Record], Error> {
        let recordsRef = db.collection("records")
        
        let subject = PassthroughSubject<[Record], Error>()
        
        recordsRef.whereField("created_by_uid", isEqualTo: Auth.auth().currentUser!.uid).order(by: "created_at", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
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
        let recordsRef = db.collection("records")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<Record?, Error>()
        var modifyRecord = record
        modifyRecord.created_at = Timestamp()
        
        if (record.images.count > 0) {
            // upload images
            let taskGroup = DispatchGroup()
            var images_url: [String] = []
            
            for _ in record.images {
                images_url.append("")
            }
            
            for (index, image) in record.images.enumerated()  {
                taskGroup.enter()
                self.uploadMedia(image: image, folder: "record_images", extention: ".jpg") { (url) in
                    images_url[index] = url!
                    taskGroup.leave()
                }
            }
            
            taskGroup.notify(queue: .main) {
                modifyRecord.images_url = images_url
                let docData = try! FirestoreEncoder().encode(modifyRecord)
                
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
            }
           
        } else {
            let docData = try! FirestoreEncoder().encode(modifyRecord)
            
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
        }
        
        return subject.eraseToAnyPublisher()

    }
    
}
