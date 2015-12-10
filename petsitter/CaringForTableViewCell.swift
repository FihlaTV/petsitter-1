//
//  CaringForTableViewCell.swift
//  petsitter
//
//  Created by MU IT Program on 12/9/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit

class CaringForTableViewCell: UITableViewCell {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petBioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
