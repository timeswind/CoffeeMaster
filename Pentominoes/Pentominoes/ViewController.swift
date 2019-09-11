//
//  ViewController.swift
//  Pentominoes
//
//  Created by Mingtian Yang on 9/11/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainBoard: UIImageView!
    @IBOutlet weak var board0Button: UIButton!
    @IBOutlet weak var board1Button: UIButton!
    @IBOutlet weak var board2Button: UIButton!
    @IBOutlet weak var board3Button: UIButton!
    @IBOutlet weak var board4Button: UIButton!
    @IBOutlet weak var board5Button: UIButton!
    
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeBoard(_ sender: Any) {
        let senderButton:UIButton = sender as! UIButton
        let tag = senderButton.tag
        mainBoard.image = UIImage(named: "Board\(tag)@3x.png")
    }
    
}

