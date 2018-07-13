//
//  SignInViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate{
   
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var txtfldUserName: UITextField!
    @IBOutlet weak var txtfldPassword: UITextField!
    fileprivate var defaults: UserDefaults = UserDefaults.standard
    private var isEmailValid = false
    private var isPasswordValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.btnSignin.backgroundColor = UIColor.lightGray
        
        txtfldUserName.setLeftIcon(UIImage(named: "mailIcon")!, textField: txtfldUserName)
        txtfldPassword.setLeftIcon(UIImage(named: "PwKEy")!, textField: txtfldPassword)
        
        self.txtfldUserName.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldPassword.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden  = true
      //  self.validPassword()
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func validEmail() {
        
        if let email = txtfldUserName.text, !email.isEmpty && email.count <= 40 && email.isEmail()
        {
            isEmailValid = true
        }
        else
        {
            isEmailValid = false
        }
    }
    
    fileprivate func validPassword() {
        
        if let pw = txtfldPassword.text, !pw.isEmpty && pw.count > 0
        {
            isPasswordValid = true
            
        }
        else
        {
            isPasswordValid = false
        }
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
        self.validateForm()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        textField.layoutIfNeeded()
        switch textField {
        case self.txtfldUserName:
            self.isEmailValid = true
            self.validateForm()
            break
        case self.txtfldPassword:
            self.isPasswordValid = true
            self.validateForm()
            break
        default:
            break
        }
        
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isEmailValid && isPasswordValid)
        {
            self.btnSignin.isEnabled = true
            self.btnSignin.backgroundColor = UIColor.warmGrey()
            return true
        }
        self.btnSignin.isEnabled = false
        self.btnSignin.backgroundColor = UIColor.lightGray
        return false
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
    
        self.view.endEditing(true)
        if (self.validateForm()) {
            self.signIn()
        }
    }
    
    func signInWithSocial(_ email: String, name : String)
    {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.signInWithSocial(email, name: name, handler:  { (success, response) -> Void in
            
            print("signIn()")
            if (success) {
                
                print(response!)
                CurrentUser.sharedInstance.save()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.goToHome(true, afterLaunchScreen: true)
                //self.startUpRequests()
                
            }
            else {
                if let error: HelloOmanError = response as? HelloOmanError {
                    switch error.code {
                    case .noInternet:
                        self.showErrorAlert(error)
                    default:
                        self.showErrorAlert(error)
                        break
                    }
                }
                MBProgressHUD.dismissGlobalHUD()
            }
            
        })
    }
    
    func signIn()
    {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.signIn((self.txtfldUserName.text?.lowercased())!, password: self.txtfldPassword.text!) { (success, response) -> Void in
            print("signIn()")
            if (success) {
                
                print(response!)
                CurrentUser.sharedInstance.save()
                print(self.txtfldPassword.text!)
                self.defaults.set(self.txtfldPassword.text, forKey: "password")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.goToHome(true, afterLaunchScreen: true)
                //self.startUpRequests()
                
            }
            else {
                if let error: HelloOmanError = response as? HelloOmanError {
                    switch error.code {
                   
                    case .noInternet:
                        self.showErrorAlert(error)
                    default:
                        self.showErrorAlert(error)
                        break
                    }
                }
                MBProgressHUD.dismissGlobalHUD()
            }
            
        }
    }
    
    @IBAction func btnFbClicked(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
       
        DispatchQueue.main.async {
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                MBProgressHUD.showHUDAddedGlobal()
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        MBProgressHUD.dismissGlobalHUD()
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }

    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    let json = JSON(result!)
                    print(json)
                    self.signInWithSocial(json["email"].stringValue, name: json["name"].stringValue)
                }
            })
        }
    }
    

    @IBAction func btnGoogleClicked(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            print(userId!)
            print(idToken!)
            print(fullName!)
            print(givenName!)
            print(familyName!)
            print(email!)
            self.signInWithSocial(email!, name: fullName!)
        } else {
            print(error)
        }
    }
    
    private func signInWillDispatch(signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
