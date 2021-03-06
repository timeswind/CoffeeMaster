//
//  BrewViewWebservice.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/23/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

extension WebDatabaseQueryService {
    func getMyBrewGuides(query: String) -> AnyPublisher<[BrewGuide], Error> {
        let brewGuidesRef = db.collection("brew_guides")

        let subject = PassthroughSubject<[BrewGuide], Error>()
        
        brewGuidesRef.whereField("created_by_uid", isEqualTo: Auth.auth().currentUser!.uid).order(by: "created_at", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var brewGuides: [BrewGuide] = []
                for document in querySnapshot!.documents {
                    let brewGuide = try! FirestoreDecoder().decode(BrewGuide.self, from: document.data())
                    brewGuide.id = document.documentID
                    brewGuides.append(brewGuide)
                }
                subject.send(brewGuides)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func createBrewGuide(brewGuide: BrewGuide)  -> AnyPublisher<BrewGuide?, Error> {
        let brewGuidesRef = db.collection("brew_guides")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<BrewGuide?, Error>()
        
        brewGuide.created_at = Timestamp()

        let docData = try! FirestoreEncoder().encode(brewGuide)

        newDocRef = brewGuidesRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                let newBrewGuide = brewGuide
                newBrewGuide.id = newDocRef!.documentID
                subject.send(newBrewGuide)
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
