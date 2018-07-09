//
//  ForgotPwViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class ChangePwViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtfldOLDPW: UITextField!
    @IBOutlet weak var txtfldNewPW: UITextField!
    @IBOutlet weak var txtfldConfmNewPW: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    private var isOldPw = false
    private var isNewPw = false
    private var isConfirmationNewPw = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.btnUpdate.backgroundColor = UIColor.lightGray
        self.btnUpdate.isEnabled = false
        // Do any additional setup after loading the view.
        self.txtfldOLDPW.addTarget(self, action: #selector(ChangePwViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldNewPW.addTarget(self, action: #selector(ChangePwViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldConfmNewPW.addTarget(self, action: #selector(ChangePwViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        self.getUpdatedPassword((CurrentUser.sharedInstance.user?.email)!, old: self.txtfldOLDPW.text!, confirm: self.txtfldNewPW.text!)
    }
    
    func getUpdatedPassword(_ email : String,old : String, confirm: String)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.callingChangePasswordAPI(email, old: old, confirm:confirm, handler: { (response,responseCode, error) in
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
                MBProgressHUD.dismissGlobalHUD()
                if responseCode == "1"
                {
                    self.showAlert("Success !!!", message: response!)
                }
                else
                {
                     self.showAlert("Oops !!!", message: response!)
                }
                
            }
        })
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        textField.layoutIfNeeded()
        switch textField {
        case self.txtfldOLDPW:
            self.isOldPw = true
            self.validateForm()
            break
        case self.txtfldNewPW:
            self.isNewPw = true
            self.validateForm()
            break
        case self.txtfldConfmNewPW:
            self.isConfirmationNewPw = true
            self.validateForm()
            break
        default:
            break
        }
        
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isOldPw && isNewPw && isConfirmationNewPw)
        {
            self.btnUpdate.isEnabled = true
            self.btnUpdate.backgroundColor = UIColor.warmGrey()
            return true
        }
        self.btnUpdate.isEnabled = false
        self.btnUpdate.backgroundColor = UIColor.lightGray
        return false
    }
    
    
    @IBAction func btnMenuClikced(_ sender: Any) {
        
        self.openLeft()
    }
    
}
