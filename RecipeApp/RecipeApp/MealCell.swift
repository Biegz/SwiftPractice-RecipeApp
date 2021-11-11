//
//  MealCell.swift
//  RecipeApp
//
//  Cell specific elements can be adjusted here. 
//
//  Created by Austin Biegler on 11/10/21.
//

import UIKit

class MealCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
