//
//  MyAccountViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtfldName: UITextField!
    @IBOutlet weak var txtfldEmail: UITextField!
    @IBOutlet weak var txtfldMobile: UITextField!
    @IBOutlet weak var txtfldTravelAgentCode: UITextField!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var btnUpload: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
     self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        
        self.imgProfile.layer.borderColor = UIColor.warmGrey().cgColor
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.size.width/2
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UITextViewDelegate protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextTextField.becomeFirstResponder()
            textField.resignFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        
    }
    
    @IBAction func btnUploadClicked(_ sender: Any) {
        
    }
    
 
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.openLeft()
    }
    
}
