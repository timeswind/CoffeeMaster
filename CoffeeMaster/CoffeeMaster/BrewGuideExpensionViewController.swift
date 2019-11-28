//
//  BrewGuideExpensionViewController.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/28/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit
import expanding_collection

class BrewGuideExpensionViewController: ExpandingViewController {

    override func viewDidLoad() {
        itemSize = CGSize(width: 214, height: 460) //IMPORTANT!!! Height of open state cell
        super.viewDidLoad()

        // register cell
        let nib = UINib(nibName: "NibName", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "CellIdentifier")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
