//
//  View+listSeparatorStyleNone.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}
