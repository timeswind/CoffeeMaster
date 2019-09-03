//
//  ViewController.swift
//  WordScramble
//
//  Created by Mingtian Yang on 9/3/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let DEFULT_WORD_SIZE:Int! = 4
    let wordModel = WordModel()
    @IBOutlet weak var WordDisplayLabel: UILabel!
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var WordSegments: UISegmentedControl!
    @IBOutlet weak var ChooseWordLengthSegment: UISegmentedControl!
    @IBOutlet weak var UndoButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var NewWordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetAll()
        
        // Do any additional setup after loading the view.
    }
    
    func resetAll() {
        //initialize UI element status
        CheckButton.isEnabled = false
        UndoButton.isEnabled = false
        WordDisplayLabel.text = " "
        WordSegments.removeAllSegments()
    }

    @IBAction func NewWordOnClick(_ sender: Any) {
        var currentWordSize: Int!
        
        //generate new word based on selected word size
        if let wordSizeTitle = ChooseWordLengthSegment.titleForSegment(at: ChooseWordLengthSegment.selectedSegmentIndex) {
             currentWordSize = Int(wordSizeTitle)
        } else {
            currentWordSize = DEFULT_WORD_SIZE
        }
        wordModel.setCurrentWordSize(newSize: currentWordSize)
        updateWordSegmentWithNewWord(newWord: wordModel.randomWord)
        
        //print(wordModel.randomWord)
    }
    
    func updateWordSegmentWithNewWord(newWord: String!) {
        var charArray = [Character](newWord)
        charArray.shuffle();
        //reset the segment
        WordSegments.removeAllSegments()
        
        //Display the shuffled characters in the word segment
        for (index, char) in charArray.enumerated() {
            WordSegments.insertSegment(withTitle: (String)(char), at: index, animated: true)
        }
    }
    
    func updateWordLabelWithNewChar(newChar: Character!) {
        if let currentWordDisplayLabelText = WordDisplayLabel.text {
            WordDisplayLabel.text = currentWordDisplayLabelText + String(newChar)
        }
    }
    
    @IBAction func CharOnChoose(_ sender: Any) {
        var choosedChar: Character!
        
        //generate new word based on selected word size
        if let segTitle = WordSegments.titleForSegment(at: WordSegments.selectedSegmentIndex) {
            choosedChar = segTitle.first
        }
        
        //let the segment selet process act like a button click
        WordSegments.selectedSegmentIndex = -1
        //print(choosedChar!)
        updateWordLabelWithNewChar(newChar: choosedChar!)

    }
}

