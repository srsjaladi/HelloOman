//
//  InclusionsTableViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class InclusionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblInclusions: UILabel!
    @IBOutlet weak var conteView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.conteView.layer.cornerRadius = 15 // Your choice here.
        self.conteView.clipsToBounds = true
        self.conteView.layer.shadowColor = UIColor.black.cgColor
        self.conteView.layer.shadowOffset = CGSize(width:1, height:1)
        self.conteView.layer.shadowOpacity = 1
        self.conteView.layer.shadowRadius = 0.5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
