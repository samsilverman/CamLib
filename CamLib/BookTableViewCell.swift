//
//  BookTableViewCell.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/28/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    var bookJSON: [String : Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
