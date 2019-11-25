//
//  ConnectViewWebDatabaseService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

extension WebDatabaseQueryService {
    func getAllPosts(query: String) -> AnyPublisher<[Post], Error> {
        let postsRef = db.collection("posts")

        let subject = PassthroughSubject<[Post], Error>()
        
        postsRef.getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var posts: [Post] = []
                for document in querySnapshot!.documents {
                    var post = try! FirestoreDecoder().decode(Post.self, from: document.data())
                    print("Post: \(post)")
                    post.id = document.documentID
                    posts.append(post)
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
        
        let docData = try! FirestoreEncoder().encode(post)
        
        newDocRef = postsRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                var newpost = post
                newpost.id = newDocRef!.documentID
                subject.send(newpost)
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
