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
    
    private var isNameValid = false
    private var isEmailValid = false
    private var isMobileNumValid = false
    private var isTravelCodeValid = false
    private var isPwdValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.btnForSignup.backgroundColor = UIColor.lightGray
        
         txtfldName.setLeftIcon(UIImage(named: "UserIcon")!, textField: txtfldName)
         txtfldEmail.setLeftIcon(UIImage(named: "mailIcon")!, textField: txtfldEmail)
         txtfldMobilenum.setLeftIcon(UIImage(named: "PhoneIcon")!, textField: txtfldMobilenum)
         txtfldTravellCode.setLeftIcon(UIImage(named: "CodeIcon")!, textField: txtfldTravellCode)
         txtfldPwd.setLeftIcon(UIImage(named: "PwKEy")!, textField: txtfldPwd)
     
        self.txtfldName.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldEmail.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldMobilenum.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldTravellCode.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldPwd.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
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
                    case .Default:
                        self.showErrorAlert(error)
                        break
                    default:
                        self.showErrorAlert(error)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var txtAfterUpdate: NSString = textField.text! as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        
        if textField == self.txtfldMobilenum
        {
            if (txtAfterUpdate.length > 8)
            {
                return false
            }
        }

        if textField == self.txtfldTravellCode {
           
            if(txtAfterUpdate.length > 9)
            {
                return false
            }
            else
            {
                return true
            }
        
        }
        
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        textField.layoutIfNeeded()
        switch textField {
        case self.txtfldName:
            if textField.text == ""
            {
                self.isNameValid = false
            }
            else{
                self.isNameValid = true
            }
            self.validateForm()
            break
        case self.txtfldEmail:
            if textField.text == ""
            {
                self.isEmailValid = false
            }
            else{
                self.isEmailValid = true
            }
            self.validateForm()
            break
        case self.txtfldMobilenum:
            if textField.text == ""
            {
                self.isMobileNumValid = false
            }
            else{
                self.isMobileNumValid = true
            }
            self.validateForm()
            break
        case self.txtfldTravellCode:
            if textField.text == ""
            {
                self.isTravelCodeValid = false
            }
            else{
                self.isTravelCodeValid = true
            }
            self.validateForm()
            break
        case self.txtfldPwd:
            if textField.text == ""
            {
                self.isPwdValid = false
            }
            else
            {
                self.isPwdValid = true
            }
            
            self.validateForm()
            break
        default:
            break
        }
        
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isNameValid && isEmailValid && isPwdValid && isMobileNumValid && isTravelCodeValid)
        {
            if  isTravelCodeValid && (self.txtfldTravellCode.text?.count == 9)
            {
                self.btnForSignup.isEnabled = true
                self.btnForSignup.backgroundColor = UIColor.warmGrey()
                return true
            }
            else
            {
                self.showAlert("Error", message: "Please enter correct code.")
            }
        }
        self.btnForSignup.isEnabled = false
        self.btnForSignup.backgroundColor = UIColor.lightGray
        return false
        
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
