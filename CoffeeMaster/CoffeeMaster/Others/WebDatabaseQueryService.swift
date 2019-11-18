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
    
    func getAllPosts() -> AnyPublisher<[Post], Error> {
        let postsRef = db.collection("posts")

        let subject = PassthroughSubject<[Post], Error>()
        
        postsRef.getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var posts: [Post] = []
                for document in querySnapshot!.documents {
                    let post = Post(dictionary: document.data())
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
                subject.send(post)
            }
        }
        return subject.eraseToAnyPublisher()
    }

}
