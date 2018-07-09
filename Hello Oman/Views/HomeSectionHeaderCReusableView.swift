//
//  SearchSectionHeaderCReusableView.swift
//  Kollectin
//
//  Created by Sivaramsingh on 31/05/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

class HomeSectionHeaderCReusableView: UITableViewHeaderFooterView {

 
    @IBOutlet weak var lblSideTitle: UILabel!
    @IBOutlet weak var viewForContent: UIView!
    @IBOutlet weak var btnForPlan: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblDynamic: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var BtnleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var BtntailingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
   
}
