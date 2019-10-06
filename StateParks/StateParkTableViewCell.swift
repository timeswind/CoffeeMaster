//
//  StateParkTableViewCell.swift
//  StateParks
//
//  Created by Mingtian Yang on 10/6/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class StateParkTableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var parkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
