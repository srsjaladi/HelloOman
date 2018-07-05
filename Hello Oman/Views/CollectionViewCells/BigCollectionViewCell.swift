//
//  BigCollectionViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 02/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class BigCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLatest: UILabel!
    @IBOutlet weak var imageTitle: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        // Initialization code
    }

}
