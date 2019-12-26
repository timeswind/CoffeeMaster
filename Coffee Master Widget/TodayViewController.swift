//
//  TodayViewController.swift
//  Coffee Master Widget
//
//  Created by Mingtian Yang on 12/3/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import SwiftUI
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func openURL(urlString: String) {
        let appURL = NSURL(string: urlString)
        self.extensionContext?.open(appURL! as URL, completionHandler:nil)
    }
        
    @IBSegueAction func addSwiftUIVIew(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: WidgetView(onOpenURL: { (url) in
            self.openURL(urlString: url)
        }))
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
