//
//  HintViewController.swift
//  Pentominoes
//
//  Created by Mingtian Yang on 9/23/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class HintViewController: UIViewController {
    
    @IBOutlet weak var boardImageView: UIImageView!
    var board = 0
    var hintCount = 1
    var pentominoModel:PentominoModel?
    var pieceViews: [String:UIImageView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        boardImageView.image = UIImage(named: "Board\(self.board)@3x.png")
        let allPiecePicNames = pentominoModel!.allPiecePicNames
        let allPieceSymbles = pentominoModel!.allPieceSymbles
        for i in 0..<hintCount {
            let image = UIImage(named: allPiecePicNames[i])!
            let pieceImageView = UIImageView(image: image)
            pieceViews.updateValue(pieceImageView, forKey: allPieceSymbles[i])
            boardImageView.addSubview(pieceImageView)
        }

    }
    
    override func viewDidLayoutSubviews() {
        let solutions = pentominoModel!.allSolutions
        let solution = solutions[board - 1]
        for (key, pieceImageView) in self.pieceViews {
            
            let position = solution[key]!
            let x = CGFloat(position.x * 30)
            let y = CGFloat(position.y * 30)
            let rotation = CGAffineTransform(rotationAngle: CGFloat(position.rotations) * CGFloat.pi / 2)
            let flipping = position.isFlipped ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
            let fullTransformation = flipping.concatenating(rotation)
            
            pieceImageView.frame = CGRect(x: x, y: y, width: pieceImageView.frame.width, height: pieceImageView.frame.height)
            pieceImageView.transform = fullTransformation
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
