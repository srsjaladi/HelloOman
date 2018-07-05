//
//  SignUpViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtfldName: UITextField!
    @IBOutlet weak var txtfldEmail: UITextField!
    @IBOutlet weak var txtfldMobilenum: UITextField!
    @IBOutlet weak var txtfldTravellCode: UITextField!
    @IBOutlet weak var txtfldPwd: UITextField!
    @IBOutlet weak var btnForSignup: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         txtfldName.setLeftIcon(UIImage(named: "UserIcon")!, textField: txtfldName)
         txtfldEmail.setLeftIcon(UIImage(named: "mailIcon")!, textField: txtfldEmail)
         txtfldMobilenum.setLeftIcon(UIImage(named: "PhoneIcon")!, textField: txtfldMobilenum)
         txtfldTravellCode.setLeftIcon(UIImage(named: "CodeIcon")!, textField: txtfldTravellCode)
         txtfldPwd.setLeftIcon(UIImage(named: "PwKEy")!, textField: txtfldPwd)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnForSignup(_ sender: Any) {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.signUp((self.txtfldEmail.text?.lowercased())!,name:self.txtfldName.text!,phone: self.txtfldMobilenum.text!,aganet_id:self.txtfldTravellCode.text!,password: self.txtfldPwd.text!) { (success, response) -> Void in
            
            print(response!)
            if (success) {
                print(response!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.goToHome(true, afterLaunchScreen: true)

            }
            else {
                if let error: HelloOmanError = response as? HelloOmanError {
                    switch error.code {
                    case .SignUpInvalidEmail:
                        break
                    case .SignUpCurrenPasswordInvalid:
                        break
                    case .SignUpNoInvites:
                        self.showErrorAlert("Oops!", message: "Sorry, to gain access to Kollectin, you need an invitation from an existing member. To find out more, please visit www.kollectin.com")
                        break
                    case .Default:
                        self.showErrorAlert(error)
                        break
                    default:
                        break
                    }
                }
                MBProgressHUD.dismissGlobalHUD()
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    
    
}
