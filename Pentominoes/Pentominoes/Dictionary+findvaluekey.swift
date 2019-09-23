//
//  Dictionary+findvaluekey.swift
//  Pentominoes
//
//  Created by Mingtian Yang on 9/22/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
