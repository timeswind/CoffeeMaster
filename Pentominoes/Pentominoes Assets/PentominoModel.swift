//
//  Model.swift
//  Pentominoes
//
//  Created by John Hannan on 8/28/18.
//  Copyright (c) 2018 John Hannan. All rights reserved.
//

import Foundation

// identifies placement of a single pentomino on a board
struct Position : Codable {
    var x : Int
    var y : Int
    var isFlipped : Bool
    var rotations : Int
}

// A solution is a dictionary mapping piece names ("T", "F", etc) to positions
// All solutions are read in and maintained in an array
let allNameSymbles:[String] = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]
typealias Solution = [String:Position]
typealias Solutions = [Solution]

class PentominoModel {

    let allSolutions : Solutions //[[String:[String:Int]]]
    init () {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "Solutions", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allSolutions = try decoder.decode(Solutions.self, from: data)
        } catch {
            print(error)
            allSolutions = []
        }
    }
    
    var allPieceSymbles:[String] {
        get {
            return allNameSymbles
        }
    }
    
    var allPiecePicNames:[String] {
        get {
            return allNameSymbles.map { "Piece\($0).png" }
        }
    }

}
