//
//  RecordViewWebService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore

extension WebDatabaseQueryService {
    // record
    func getMyRecords(query: String) -> AnyPublisher<[Record], Error> {
        let recordsRef = db.collection("records")

        let subject = PassthroughSubject<[Record], Error>()
        
        recordsRef.getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var records: [Record] = []
                for document in querySnapshot!.documents {
                    var record = try! FirestoreDecoder().decode(Record.self, from: document.data())
                    record.id = document.documentID
                    records.append(record)
                    print("\(document.documentID) => \(document.data())")
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

        let docData = try! FirestoreEncoder().encode(record)

        newDocRef = recordsRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                print("Document added with ID: \(newDocRef!.documentID)")
                var newrecord = record
                newrecord.id = newDocRef!.documentID
                subject.send(newrecord)
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
