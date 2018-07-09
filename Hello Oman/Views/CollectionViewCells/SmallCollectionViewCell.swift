//
//  SmallCollectionViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageTitle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15 // Your choice here.
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:1, height:1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0.5
        // Initialization code
    }

}
