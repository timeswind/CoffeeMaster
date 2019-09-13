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
//            let frame = CGRect.zero
            let image = UIImage(named: allPiecePicNames[i])!
            let pieceImageView = UIImageView(image: image)
            pieceViews.updateValue(pieceImageView, forKey: allPieceSymbles[i])
            displayBoard.addSubview(pieceImageView)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        for (index, pieceImageViewEntry) in pieceViews.enumerated() {
            let pieceImageView = pieceImageViewEntry.value
            
            let displayBoardWidth = displayBoard.bounds.width - CGFloat(SAFE_BORDER_WIDTH*2)
            let displayBoardHeight = displayBoard.bounds.height - CGFloat(SAFE_BORDER_WIDTH*2)
            
            let pieceWidth = displayBoardWidth / CGFloat(PIECE_COLUMN_COUNT)
            let pieceHeight = displayBoardHeight / CGFloat(PIECE_ROW_COUNT)

            let positionX = CGFloat(index % PIECE_COLUMN_COUNT) * pieceWidth + CGFloat(SAFE_BORDER_WIDTH)
            let positionY = CGFloat(index / PIECE_COLUMN_COUNT) * pieceHeight + CGFloat(SAFE_BORDER_WIDTH)

            pieceImageView.frame=CGRect(x: positionX, y: positionY, width: pieceImageView.frame.width, height: pieceImageView.frame.height)
            
        }
    }

    @IBAction func changeBoard(_ sender: Any) {
        let senderButton:UIButton = sender as! UIButton
        let tag = senderButton.tag
        mainBoard.image = UIImage(named: "Board\(tag)@3x.png")
    }
    
}

