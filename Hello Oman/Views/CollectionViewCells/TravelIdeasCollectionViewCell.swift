//
//  TravelIdeasCollectionViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class TravelIdeasCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgProfile.layer.cornerRadius = 15 // Your choice here.
        self.clipsToBounds = true
    }

}
