//
//  BrewGuideExpensionViewController.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/28/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import expanding_collection
import SwiftUI

class BrewGuideExpensionViewController: UIViewController {
    var brewGuides: [BrewGuide] = []
    
    convenience init( brewGuides: [BrewGuide] ) {
        self.init()
        
        self.brewGuides = brewGuides
    }
}

struct BrewGuideExpensionViewView: UIViewControllerRepresentable {
    @Binding var brewGuides: [BrewGuide]
    
    func makeUIViewController(context: Context) -> BrewGuideExpensionViewController {
        let vc = BrewGuideExpensionViewController(brewGuides: brewGuides)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: BrewGuideExpensionViewController, context: Context) {
        //
    }
}


