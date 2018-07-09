//
//  ForgotPswViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgotPswViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtfldPhoneNum: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtfldPhoneNum.setLeftIcon(UIImage(named: "PhoneIcon")!, textField: txtfldPhoneNum)
 
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
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.forgotPassword(self.txtfldPhoneNum.text!) { (success, error) -> Void in
            print("forgotPassword()")
            MBProgressHUD.dismissGlobalHUD()
            if (success) {
               self.showErrorAlert("", message: "")
            } else {
                if let error = error {
                    switch error.code
                    {
                    case .Default:
                        self.showErrorAlert(error)
                        break
                    default:
                        self.showErrorAlert(error)
                        break
                    }
                }
            }
        }
    }
    

}
