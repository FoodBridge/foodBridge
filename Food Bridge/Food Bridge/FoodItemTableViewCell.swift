//
//  FoodItemTableViewCell.swift
//  Food Bridge
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {
    //    MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButton(_ sender: UIButton) {
    }
}
