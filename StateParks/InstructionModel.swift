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
    var description: String
}
typealias Instructions = [Instruction]

class InstructionModel {
    static let shared = InstructionModel()
    
    var instructions: Instructions = Instructions()
    
    init() {
        instructions.append(Instruction(imageName: "first.png", description: "collapsable sections"))
        instructions.append(Instruction(imageName: "secound.png", description: "tappable cells to display image"))
        instructions.append(Instruction(imageName: "third.png", description: "full image view with caption"))
    }
    
    func instructionForPage(page: Int) -> Instruction {
        return instructions[page]
    }
}
