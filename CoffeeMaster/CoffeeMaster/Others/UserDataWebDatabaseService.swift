//
//  UserDataWebDatabaseService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

extension WebDatabaseQueryService {
    func updateUsername(username: String) -> AnyPublisher<String, Error> {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        let subject = PassthroughSubject<String, Error>()
        changeRequest?.commitChanges { (error) in
            if (error != nil) {
                subject.send(completion: .failure(error!))
            } else {
                subject.send(username)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }

}
