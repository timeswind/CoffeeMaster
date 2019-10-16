//
//  InstructionViewController.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/14/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var instructionDescription: UITextView!
    @IBOutlet weak var instructionImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let instruction = instructionObject {
            if let textview = instructionDescription {
                textview.font = UIFont.systemFont(ofSize: 24)
                textview.text = instruction.description
            }
            if let imageview = instructionImage {
                imageview.image = UIImage(named: instruction.imageName)
            }
            
            if let button = startButton {
                if instruction.index == 2 {
                    button.isHidden = false
                } else {
                    button.isHidden = true
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
 
    @IBAction func dismissself(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var instructionObject: Instruction? {
        didSet {
            // Update the view.
            configureView()
        }
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
