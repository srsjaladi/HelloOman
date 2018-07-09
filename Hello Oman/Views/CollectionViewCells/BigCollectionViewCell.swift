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
    @IBOutlet weak var lblTitleConstraint: NSLayoutConstraint!
    
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
