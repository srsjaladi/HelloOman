//
//  FakeLaunchScreenVC.swift
//  Kollectin
//
//  Created by Pablo on 3/4/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import UIKit
import MBProgressHUD


class FakeLaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startUpRequests()
    
    }
    
    fileprivate func startUpRequests()
    {
        MBProgressHUD.showHUDAddedGlobal()
        CurrentUser.sharedInstance.getUser(handler: {(user) -> () in
            
            if user != nil
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.goToHome(true, afterLaunchScreen: true)
            }
            else
            {
                MBProgressHUD.dismissGlobalHUD()
                CurrentUser.sharedInstance.logOut()
            }
           
        })
    }
    
    
    
}
