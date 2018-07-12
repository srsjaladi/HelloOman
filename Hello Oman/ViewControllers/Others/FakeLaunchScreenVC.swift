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
    
    @IBOutlet weak var agentImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startUpRequests()
        
        if CurrentUser.sharedInstance.user != nil {
            if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.agentInfo.agent_image)!)
            {
                self.agentImage.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
        }
    }
    
    fileprivate func startUpRequests()
    {
        MBProgressHUD.showHUDAddedGlobal()
        CurrentUser.sharedInstance.getUser(handler: {(user) -> () in
            
            if user != nil
            {
                if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.agentInfo.agent_image)!)
                {
                    self.agentImage.af_setImage(
                        withURL: imageURL,
                        placeholderImage: UIImage(named: "DefaultImage"),
                        filter: nil,
                        imageTransition: .crossDissolve(0.3)
                    )
                }
                let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.goToHome(true, afterLaunchScreen: true)
                }
                
            }
            else
            {
                MBProgressHUD.dismissGlobalHUD()
                CurrentUser.sharedInstance.logOut()
            }
           
        })
    }
    
    
    
}
