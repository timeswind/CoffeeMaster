//
//  PermissionRequestService.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/3/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import HealthKit
import Combine

class PermissionRequestService {

    init() { }

    func requestAuthorizationForHeathStore(types: Set<HKSampleType>, healthStore: HKHealthStore) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        
        healthStore.requestAuthorization(toShare: types, read: types) { (success, error) in
            if !success {
                subject.send(completion: .failure(error!))
            } else {
                subject.send(true)
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
