//
//  ItineraryViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 09/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ItineraryViewController: UIViewController {

    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var strTitle : String = ""
    var strDesc : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        lblTitle.text = strTitle
        lblDesc.text = strDesc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
