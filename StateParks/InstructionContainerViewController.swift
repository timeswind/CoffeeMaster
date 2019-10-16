//
//  InstructionContainerViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/15/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class InstructionContainerViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    let instructionModel = InstructionModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = instructionModel.instructions.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    
    func updatePage(page:Int) {
        self.pageControl.currentPage = page
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
