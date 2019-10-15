//
//  ParksModel.swift
//  StateParks
//
//  Created by Mingtian Yang on 9/26/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Foundation
import UIKit

struct Instruction: Codable {
    var imageName: String
    var index: Int
    var description: String
}

class InstructionModel {
    static let shared = InstructionModel()
    
    var instructions:[Instruction] = []
    
    init() {
        instructions.append(Instruction(imageName: "first.png",index: 0, description: "Collapsable sections (1/3) ->"))
        instructions.append(Instruction(imageName: "second.png",index: 1, description: "Tappable cells to display image (2/3) ->"))
        instructions.append(Instruction(imageName: "third.png",index: 2, description: "Full image view with caption (3/3)"))
    }
    
    func instructionForPage(page: Int) -> Instruction {
        return instructions[page]
    }

}
