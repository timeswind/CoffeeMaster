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
    var currentWordSize: Int!
    var correctAnswer: String?;
    var wordIndexesSelected = [Int]()
    
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
        WordDisplayLabel.text = ""
        ResultLabel.text = "Click \"Check\" to see result"
        ResultLabel.textColor = UIColor.black
        WordSegments.removeAllSegments()
    }

    @IBAction func NewWordOnClick(_ sender: Any) {
        resetAll()
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
        correctAnswer = newWord
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
            // no input exceeds the length of the word
            if currentWordDisplayLabelText.count < currentWordSize {
                WordDisplayLabel.text = currentWordDisplayLabelText + String(newChar)
                // enable the undo button once there is at least 1 char
                if currentWordDisplayLabelText.count == 0 {
                    UndoButton.isEnabled = true
                }
                
                // enable the check button
                if currentWordDisplayLabelText.count == currentWordSize - 1 {
                    CheckButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func Undo(_ sender: Any) {
        if let currentWordDisplayLabelText = WordDisplayLabel.text {
            if currentWordDisplayLabelText.count > 0 {
                WordDisplayLabel.text = (String)(currentWordDisplayLabelText.prefix(currentWordDisplayLabelText.count - 1))
                
                //last char could be reselect
                wordIndexesSelected.popLast()
                
                if currentWordDisplayLabelText.count == 1 {
                    UndoButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func Check(_ sender: Any) {
        if let currentWordDisplayLabelText = WordDisplayLabel.text {
            if currentWordDisplayLabelText == correctAnswer {
                ResultLabel.text = "Correct!"
                ResultLabel.textColor = UIColor.green
            } else {
                ResultLabel.text = "Wrong!"
                ResultLabel.textColor = UIColor.red
            }
        }
    }
    
    @IBAction func CharOnChoose(_ sender: Any) {
        var choosedChar: Character!
        
        //generate new word based on selected word size
        if let segTitle = WordSegments.titleForSegment(at: WordSegments.selectedSegmentIndex) {
            //each char could be selected only once
            if !(wordIndexesSelected.contains(WordSegments.selectedSegmentIndex)) {
                wordIndexesSelected.append(WordSegments.selectedSegmentIndex)
                choosedChar = segTitle.first
                //print(choosedChar!)
                updateWordLabelWithNewChar(newChar: choosedChar!)
            } else {
                
            }
        }
        
        //let the segment selet process act like a button click
        WordSegments.selectedSegmentIndex = -1

    }
}

