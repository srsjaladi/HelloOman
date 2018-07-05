//
//  ForgotPwViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ChangePwViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtfldOLDPW: UITextField!
    @IBOutlet weak var txtfldNewPW: UITextField!
    @IBOutlet weak var txtfldConfmNewPW: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnUpdateClicked(_ sender: Any) {
        
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
    
    
    @IBAction func btnMenuClikced(_ sender: Any) {
        
        self.openLeft()
    }
    
}
