//
//  ListViewTableViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnPlan: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblOMR: UILabel!
    @IBOutlet weak var lblTimeDays: UILabel!
    
    
    
    
    @IBOutlet weak var trailingConstrint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstrint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.conView.layer.cornerRadius = 15 // Your choice here.
        self.conView.clipsToBounds = true
        self.conView.layer.shadowColor = UIColor.black.cgColor
        self.conView.layer.shadowOffset = CGSize(width:1, height:1)
        self.conView.layer.shadowOpacity = 1
        self.conView.layer.shadowRadius = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
