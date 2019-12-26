//
//  String + isBlank.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/23/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
extension Optional where Wrapped == String {
    var isBlank: Bool {
        if let unwrapped = self {
            return unwrapped.isBlank
        } else {
            return true
        }
    }
}
