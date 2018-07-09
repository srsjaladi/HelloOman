//
//  AgentDetailsViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class AgentDetailsViewController: UIViewController {

    
    @IBOutlet weak var btnBg: UIButton!
    @IBOutlet weak var lblAgentEmail: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblAgentPhone: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var agentImg: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.agentInfo.agent_image)!)
        {
            self.agentImg.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "brandLogo"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        self.lblAgentName.text = String(format: "\(CurrentUser.sharedInstance.user!.agentInfo.agent_name) - \(CurrentUser.sharedInstance.user!.agentInfo.agent_unique_id)")
        self.lblAgentEmail.text = CurrentUser.sharedInstance.user?.agentInfo.agent_email
        self.lblAgentPhone.text = CurrentUser.sharedInstance.user?.agentInfo.agent_phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBgClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
