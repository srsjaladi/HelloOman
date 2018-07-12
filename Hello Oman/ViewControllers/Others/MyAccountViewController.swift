//
//  MyAccountViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyAccountViewController: UIViewController,UITextFieldDelegate,AQPhotoPickerViewDelegate {

    
    @IBOutlet weak var btnImageChange: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtfldName: UITextField!
    @IBOutlet weak var txtfldEmail: UITextField!
    @IBOutlet weak var txtfldMobile: UITextField!
    @IBOutlet weak var txtfldTravelAgentCode: UITextField!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var btnUpload: UIButton!
    
    private var isNameValid = false
    private var isEmailValid = false
    private var isMobileNumValid = false
    private var isTravlAgentCodeValid = false
    private var isPasswordValid = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.btnUpload.isEnabled = false
        self.btnUpload.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.btnImageChange.layer.borderColor = UIColor.warmGrey().cgColor
        self.btnImageChange.layer.borderWidth = 1.0
        self.btnImageChange.layer.masksToBounds = true
        self.btnImageChange.layer.cornerRadius = self.btnImageChange.layer.frame.size.width/2
        
        self.imgProfile.layer.borderColor = UIColor.warmGrey().cgColor
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.size.width/2
        
         self.txtfldName.addTarget(self, action: #selector(MyAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldEmail.addTarget(self, action: #selector(MyAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldMobile.addTarget(self, action: #selector(MyAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldTravelAgentCode.addTarget(self, action: #selector(MyAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
          self.txtfldPassword.addTarget(self, action: #selector(MyAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.setInitialData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitialData() {
        
        if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.image)!)
        {
            self.imgProfile.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        self.txtfldName.text = CurrentUser.sharedInstance.user?.name
        self.txtfldEmail.text = CurrentUser.sharedInstance.user?.email
        self.txtfldMobile.text = CurrentUser.sharedInstance.user?.phone
        self.txtfldTravelAgentCode.text = CurrentUser.sharedInstance.user?.agentInfo.agent_unique_id
        
        self.isNameValid = true
        self.isEmailValid = true
        self.isMobileNumValid = true
        self.isTravlAgentCodeValid = true
        
    }
    
   // MARK: UITextViewDelegate protocol
    
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

        if textField == self.txtfldMobile
        {
            if (txtAfterUpdate.length > 8)
            {
                return false
            }
        }
        
          if textField == self.txtfldTravelAgentCode {
            
            if (txtAfterUpdate.length == 9)
            {
                self.getAgentDetails(uniqueId: txtAfterUpdate as String)
            }
            else if (txtAfterUpdate.length > 9)
            {
                return false
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
        case self.txtfldMobile:
            if textField.text == ""
            {
                self.isMobileNumValid = false
            }
            else{
                self.isMobileNumValid = true
            }
            self.validateForm()
            break
        case self.txtfldTravelAgentCode:
            if textField.text == ""
            {
                self.isTravlAgentCodeValid = false
            }
            else {
                self.isTravlAgentCodeValid = true
            }
            self.validateForm()
            break
        case self.txtfldPassword:
            if textField.text == ""
            {
                self.isPasswordValid = false
            }
            else
            {
                self.isPasswordValid = true
            }
            
            self.validateForm()
            break
        default:
            break
        }
        
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isNameValid && isEmailValid && isPasswordValid && isPasswordValid)
        {
            if isTravlAgentCodeValid && (self.txtfldTravelAgentCode.text?.count == 9)
            {
                self.btnUpload.isEnabled = true
                self.btnUpload.setTitleColor(UIColor.warmGrey(), for: .normal)
                return true
            }
            else
            {
                self.showAlert("Error", message: "Please enter correct code.")
            }
            
        }
        self.btnUpload.isEnabled = false
        self.btnUpload.setTitleColor(UIColor.lightGray, for: .normal)
        return false
    }
    
    
    @IBAction func btnUploadClicked(_ sender: Any) {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.callingUpdatedAccountAPI((CurrentUser.sharedInstance.user?.id)!, name: self.txtfldName.text!, email: self.txtfldEmail.text!, phone: self.txtfldMobile.text!, agent_id: (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!, handler: { (response,responseCode, error) in
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
    
    func getAgentDetails(uniqueId: String)  {
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAgentDetails(uniqueId, handler: { (success, response,responseCode, error) in
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
                    let alert = UIAlertController(title: "Success !!!" , message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title:
                        "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            let agentDetailsVC = homeStoryboard.instantiateViewController(withIdentifier: "AgentDetailsViewController") as! AgentDetailsViewController
                            self.present(agentDetailsVC, animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
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
 
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.openLeft()
    }
    
    @IBAction func btnForImageClicked(_ sender: Any) {
        AQPhotoPickerView.present(in: self)
    }
    
    // MARK: AQPhotoPickerViewDelegate methods
    
    func photo(fromImagePickerView photo: UIImage!) {
        self.imgProfile.image = photo
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.ChangeProfilImage(userId: (CurrentUser.sharedInstance.user?.id)!, ProfilePicture: photo, handler: { (response,responseCode, error) in
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
                    self.showAlert("Success !!!", message:"")
                    CurrentUser.sharedInstance.user?.image = response!
                }
                else
                {
                    self.showAlert("Oops !!!", message:"")
                }
                
            }
        })
    }
}
