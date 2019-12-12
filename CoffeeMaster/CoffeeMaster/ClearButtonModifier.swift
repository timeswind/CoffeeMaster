//
//  ClearButtonModifier.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/12/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import SwiftUI

struct ClearButton: ViewModifier
{
    @Binding var text: String

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content

            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                })
                {
                    Image("icons-delete-128").resizable().frame(width: 20, height: 20)
                }.buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)
            }
        }
    }
}
