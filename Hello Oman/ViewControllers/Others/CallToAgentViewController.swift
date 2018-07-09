//
//  CallToAgentViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 09/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class CallToAgentViewController: UIViewController {

    
    @IBOutlet weak var ImgView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getImages()
        // Do any additional setup after loading the view.
    }

    func getImages()  {
       // MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getBrandImageDetails({ (ImagesList, error) in
            if let error: HelloOmanError = error {
                MBProgressHUD.dismissGlobalHUD()
                switch error.code {
                case .Default:
                    self.showErrorAlert(error)
                    break
                default:
                    self.showErrorAlert(error)
                    break
                }
            }
            else
            {
            //    MBProgressHUD.dismissGlobalHUD()
                if (ImagesList?.count)! > 0
                {
                    if let imageURL = URL(string: (ImagesList![0].image))
                    {
                        self.ImgView.af_setImage(
                            withURL: imageURL,
                            placeholderImage: UIImage(named: "DefaultImage"),
                            filter: nil,
                            imageTransition: .crossDissolve(0.3)
                        )
                    }
                }
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnYesClicked(_ sender: Any) {
        
        if let url = URL(string: "tel://\(CurrentUser.sharedInstance.user!.agentInfo.agent_phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            print("Your device doesn't support this feature.")
        }
        
    }
    
    @IBAction func btnBgClicked(_ sender: Any) {
         self.dismiss(animated: false, completion: nil)
    }
    
}
