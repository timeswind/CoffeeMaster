//
//  WebDatabaseQueryService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/17/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore

class WebDatabaseQueryService {
    var db: Firestore!
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        self.decoder = decoder
    }
    
    func getAllPosts(query: String) -> AnyPublisher<[Post], Error> {
        let postsRef = db.collection("posts")

        let subject = PassthroughSubject<[Post], Error>()
        
        postsRef.getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var posts: [Post] = []
                for document in querySnapshot!.documents {
                    var post = Post(dictionary: document.data())
                    post.id = document.documentID
                    posts.append(post)
                    print("\(document.documentID) => \(document.data())")
                }
                print(posts)
                subject.send(posts)
            }
        }
        
        
        return subject.eraseToAnyPublisher()
    }
    
    func newPost(post: Post)  -> AnyPublisher<Post?, Error> {
        let postsRef = db.collection("posts")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<Post?, Error>()

        newDocRef = postsRef.addDocument(data: [
            "title": post.title,
            "body": post.body,
            "created_at": Timestamp(date: Date()),
            "created_by_uid": post.created_by_uid,
            "allow_comment": post.allow_comment,
            "likes": 0
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                print("Document added with ID: \(newDocRef!.documentID)")
                var newpost = post
                newpost.id = newDocRef!.documentID
                subject.send(newpost)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
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
                    var record = Record(dictionary: document.data())
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

        newDocRef = recordsRef.addDocument(data: [
            "title": record.title,
            "body": record.body,
            "created_at": Timestamp(date: Date()),
            "created_by_uid": record.created_by_uid
        ]) { err in
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
