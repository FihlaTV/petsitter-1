//
//  PetTableViewCell.swift
//  petsitter
//
//  Created by MU IT Program on 11/30/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
