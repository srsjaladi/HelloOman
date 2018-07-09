//
//  TravelItemsHeaderView.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 09/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TravelItemsHeaderView: UIView {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgViewHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
     @IBOutlet weak var btnBack: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

}
