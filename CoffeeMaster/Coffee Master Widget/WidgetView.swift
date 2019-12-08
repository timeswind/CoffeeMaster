//
//  WidgetView.swift
//  Coffee Master Widget
//
//  Created by Mingtian Yang on 12/3/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    var onOpenURL: ((String) -> Void)?
    
    func openURL(urlString: String) {
        if let onOpenURL = self.onOpenURL {
            onOpenURL(urlString)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {self.openURL(urlString: "coffeemaster://brew")}) { Text("Open Brew View") }
                Button(action: {self.openURL(urlString: "coffeemaster://record")}) { Text("Open Record View") }
            }
            Button(action: {self.openURL(urlString: "coffeemaster://record.caffeine")}) { Text("RecordCaffeine") }
            Spacer()
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
