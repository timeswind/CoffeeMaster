//
//  DecimalTextField.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine

struct DecimalTextField: View {
    @Binding var bindText: String
    
    private class DecimalTextFieldViewModel: ObservableObject {
        @Published var text = ""
        private var subCancellable: AnyCancellable!
        private var validCharSet = CharacterSet(charactersIn: "1234567890.")

        init() {
            subCancellable = $text.sink { val in
                //check if the new string contains any invalid characters
                if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                    //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                    DispatchQueue.main.async {
                        self.text = String(self.text.unicodeScalars.filter {
                            self.validCharSet.contains($0)
                        })
                    }
                }
            }
        }

        deinit {
            subCancellable.cancel()
        }
    }

    @ObservedObject private var viewModel = DecimalTextFieldViewModel()

    var body: some View {
        TextField("Type something...", text: $viewModel.text)
    }
}
