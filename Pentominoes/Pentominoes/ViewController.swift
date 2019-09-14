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
    
    @IBOutlet weak var displayBoard: UIView!
    
    let pentominoModel = PentominoModel()
    var currentBoard = 0
    var status = "ready to play"
    
    let PIECE_ROW_COUNT = 2
    let PIECE_COLUMN_COUNT = 6
    let SAFE_BORDER_WIDTH = 20
    var TOTAL_PIECE_COUNT:Int {
        get {
            return PIECE_ROW_COUNT * PIECE_COLUMN_COUNT
        }
    }
    
    //piecename:uiview
    var pieceViews: [String:UIImageView] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let allPiecePicNames = pentominoModel.allPiecePicNames
        let allPieceSymbles = pentominoModel.allPieceSymbles
        for i in 0..<TOTAL_PIECE_COUNT {
            let image = UIImage(named: allPiecePicNames[i])!
            let pieceImageView = UIImageView(image: image)
            pieceViews.updateValue(pieceImageView, forKey: allPieceSymbles[i])
            displayBoard.addSubview(pieceImageView)
        }
        resetButton.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        if (status == "ready to play") {
            for (index, pieceImageViewEntry) in pieceViews.enumerated() {
                let pieceImageView = pieceImageViewEntry.value
                
                let displayBoardWidth = displayBoard.bounds.width - CGFloat(SAFE_BORDER_WIDTH*2)
                let displayBoardHeight = displayBoard.bounds.height - CGFloat(SAFE_BORDER_WIDTH*2)
                
                let pieceWidth = displayBoardWidth / CGFloat(PIECE_COLUMN_COUNT)
                let pieceHeight = displayBoardHeight / CGFloat(PIECE_ROW_COUNT)
                
                let positionX = CGFloat(index % PIECE_COLUMN_COUNT) * pieceWidth + CGFloat(SAFE_BORDER_WIDTH)
                let positionY = CGFloat(index / PIECE_COLUMN_COUNT) * pieceHeight + CGFloat(SAFE_BORDER_WIDTH)
                
                pieceImageView.frame = CGRect(x: positionX, y: positionY, width: pieceImageView.frame.width, height: pieceImageView.frame.height)
            }
        }
    }

    @IBAction func solve(_ sender: Any) {
        let solutions = pentominoModel.allSolutions
        if (currentBoard != 0) {
            let solution = solutions[currentBoard - 1]
            
            for (key, pieceImageView) in pieceViews {

                let position = solution[key]!
                let x = CGFloat(position.x * 30)
                let y = CGFloat(position.y * 30)
                let rotation = CGAffineTransform(rotationAngle: CGFloat(position.rotations) * CGFloat.pi / 2)
                let flipping = position.isFlipped ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
                let fullTransformation = flipping.concatenating(rotation)
            
                UIView.animate(withDuration: 1, animations: {
                    pieceImageView.transform = fullTransformation
                    let frame = CGRect(x: x, y: y, width: pieceImageView.frame.width, height: pieceImageView.frame.height)
                    let newFrame = self.mainBoard.convert(frame, to: self.displayBoard)
                    pieceImageView.frame = newFrame
                }) { (complete) in
                    if (complete) {
                        let newFrame = self.displayBoard.convert(pieceImageView.frame, to: self.mainBoard)
                        pieceImageView.frame = newFrame
                        self.mainBoard.addSubview(pieceImageView)
                    }
                }
            }
            
            solveButton.isEnabled = false
            hintButton.isEnabled = false
            resetButton.isEnabled = true
            status = "finished"
        }

        
    }
    
    @IBAction func reset(_ sender: Any) {

        for (index, pieceViewEntry) in pieceViews.enumerated() {
            let pieceImageView = pieceViewEntry.value
            let newFrame = self.mainBoard.convert(pieceImageView.frame, to: self.displayBoard)
            self.displayBoard.addSubview(pieceImageView)
            pieceImageView.frame = newFrame

            
            let displayBoardWidth = displayBoard.bounds.width - CGFloat(SAFE_BORDER_WIDTH * 2)
            let displayBoardHeight = displayBoard.bounds.height - CGFloat(SAFE_BORDER_WIDTH * 2)

            let pieceWidth = displayBoardWidth / CGFloat(PIECE_COLUMN_COUNT)
            let pieceHeight = displayBoardHeight / CGFloat(PIECE_ROW_COUNT)

            let positionX = CGFloat(index % PIECE_COLUMN_COUNT) * pieceWidth + CGFloat(SAFE_BORDER_WIDTH)
            let positionY = CGFloat(index / PIECE_COLUMN_COUNT) * pieceHeight + CGFloat(SAFE_BORDER_WIDTH)

            let newFrame2 = CGRect(x: positionX, y: positionY, width: pieceImageView.bounds.width, height: pieceImageView.bounds.height)

            UIView.animate(withDuration: 1, animations: {
                pieceImageView.transform = CGAffineTransform.identity
                pieceImageView.frame = newFrame2
            })
        }
        
        solveButton.isEnabled = true
        hintButton.isEnabled = true
        resetButton.isEnabled = false
        status = "ready to play"
    }
    
    @IBAction func changeBoard(_ sender: Any) {
        let senderButton:UIButton = sender as! UIButton
        let tag = senderButton.tag
        currentBoard = tag
        mainBoard.image = UIImage(named: "Board\(tag)@3x.png")
    }
    
}

