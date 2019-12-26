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
import CodableFirebase

extension WebDatabaseQueryService {
    func getAllPosts(query: String) -> AnyPublisher<[Post], Error> {
        let postsRef = db.collection("posts")
        
        let subject = PassthroughSubject<[Post], Error>()
        
        postsRef.order(by: "created_at", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var posts: [Post] = []
                for document in querySnapshot!.documents {
                    var post = try! FirestoreDecoder().decode(Post.self, from: document.data())
                    post.id = document.documentID
                    posts.append(post)
                }
                subject.send(posts)
                
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func getComments(forPost id: String) -> AnyPublisher<[Comment], Error> {
        let commentsRef = db.collection("comments")
        
        let subject = PassthroughSubject<[Comment], Error>()
        
        commentsRef.whereField("post_id", isEqualTo: id).order(by: "created_at", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var comments: [Comment] = []
                for document in querySnapshot!.documents {
                    var comment = try! FirestoreDecoder().decode(Comment.self, from: document.data())
                    comment.id = document.documentID
                    comments.append(comment)
                }
                subject.send(comments)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func postComment(comment: Comment) -> AnyPublisher<Comment?, Error> {
        let commentsRef = db.collection("comments")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<Comment?, Error>()
        var modifyComment = comment
        modifyComment.created_at = Timestamp()
        if let author_name = Auth.auth().currentUser?.displayName {
            modifyComment.author_name = author_name
        }
        
        let docData = try! FirestoreEncoder().encode(modifyComment)
        
        newDocRef = commentsRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                var newcomment = modifyComment
                newcomment.id = newDocRef!.documentID
                subject.send(newcomment)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func newPost(post: Post)  -> AnyPublisher<Post?, Error> {
        let postsRef = db.collection("posts")
        var newDocRef: DocumentReference? = nil
        
        let subject = PassthroughSubject<Post?, Error>()
        var modifyPost = post
        modifyPost.created_at = Timestamp()
        if let author_name = Auth.auth().currentUser?.displayName {
            modifyPost.author_name = author_name
        }
        
        if (post.images.count > 0) {
            let taskGroup = DispatchGroup()
            var images_url: [String] = []
            
            for _ in post.images {
                images_url.append("")
            }
            
            for (index, image) in post.images.enumerated()  {
                taskGroup.enter()
                self.uploadMedia(image: image, folder: "post_images", extention: ".jpg") { (url) in
                    images_url[index] = url!
                    taskGroup.leave()
                }
            }
            
            taskGroup.notify(queue: .main) {
                modifyPost.images_url = images_url
                let docData = try! FirestoreEncoder().encode(modifyPost)
                
                newDocRef = postsRef.addDocument(data: docData) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        subject.send(nil)
                    } else {
                        var newpost = modifyPost
                        newpost.id = newDocRef!.documentID
                        subject.send(newpost)
                    }
                }
            }
            
        }
        
        
        let docData = try! FirestoreEncoder().encode(modifyPost)
        
        newDocRef = postsRef.addDocument(data: docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                subject.send(nil)
            } else {
                var newpost = modifyPost
                newpost.id = newDocRef!.documentID
                subject.send(newpost)
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func updatePost(post: Post) -> AnyPublisher<Bool, Error> {
        let postRef = db.collection("posts").document(post.id!)
        let docData = try! FirestoreEncoder().encode(post)
        
        let subject = PassthroughSubject<Bool, Error>()
        
        postRef.setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
                subject.send(false)
            } else {
                subject.send(true)
            }
            
        }
        
        return subject.eraseToAnyPublisher()
    }
}
