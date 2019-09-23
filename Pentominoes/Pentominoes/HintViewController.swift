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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardImageView.image = UIImage(named: "Board\(self.board)@3x.png")
        let allPiecePicNames = pentominoModel!.allPiecePicNames
        let allPieceSymbles = pentominoModel!.allPieceSymbles
        for i in 0..<hintCount {
            let image = UIImage(named: allPiecePicNames[i])!
            let pieceImageView = UIImageView(image: image)
            boardImageView.addSubview(pieceImageView)
        }

    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
