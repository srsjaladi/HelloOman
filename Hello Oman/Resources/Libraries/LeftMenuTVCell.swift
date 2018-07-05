//
//  LeftMenuTVCell.swift
//  Kollectin
//
//  Created by Pablo on 1/11/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import UIKit

class LeftMenuTVCell: UITableViewCell {

	@IBOutlet weak var picker: UIImageView!
	@IBOutlet weak var titlemenu: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
