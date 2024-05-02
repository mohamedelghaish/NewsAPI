//
//  FavoriteTableViewCell.swift
//  Day6NewsAPI
//
//  Created by Mohamed Kotb Saied Kotb on 30/04/2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var favImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
