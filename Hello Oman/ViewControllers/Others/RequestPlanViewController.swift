//
//  RequestPlanViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 06/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class RequestPlanViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource,
UIPickerViewDelegate {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserPhoneNum: UILabel!
    @IBOutlet weak var txtfldCountry: UITextField!
    @IBOutlet weak var txtfldDepartureCity: UITextField!
    @IBOutlet weak var txtfldArrivalCity: UITextField!
    @IBOutlet weak var txtfldDate: PickerTextField!
    @IBOutlet weak var txtfldNoOfPersons: PickerTextField!
    @IBOutlet weak var txtfldNoOfDays: PickerTextField!
    @IBOutlet weak var txtfldBudget: PickerTextField!
    @IBOutlet weak var btnRequest: UIButton!
    
    var arrForPersons = [String]()
    var arrForDays = [String]()
    var arrForBudgets = [String]()
    private var isCountryValid = false
    private var isDepartureValid = false
    private var isArrivalValid = false
    private var isDateValid = false
    private var isPersonsValid = false
    private var isDaysValid = false
    private var isBudgetValid = false
    
    fileprivate var datePicker: UIDatePicker!
    fileprivate var personsPicker: UIPickerView!
    fileprivate var daysPicker: UIPickerView!
    fileprivate var budgetPicker: UIPickerView!
    
    var strSubject : String = ""
    var strImage : String = "Enquiry"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
         self.btnRequest.backgroundColor = UIColor.gray
        self.lblUsername.text = CurrentUser.sharedInstance.user?.name
        self.lblUserEmail.text = CurrentUser.sharedInstance.user?.email
        self.lblUserPhoneNum.text = CurrentUser.sharedInstance.user?.phone
        
        self.txtfldDate.tintColor = .clear
        self.txtfldNoOfPersons.tintColor = .clear
        self.txtfldNoOfDays.tintColor = .clear
        self.txtfldBudget.tintColor = .clear
        self.txtfldCountry.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldDepartureCity.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldArrivalCity.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldDate.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldNoOfPersons.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        self.txtfldNoOfDays.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
         self.txtfldBudget.addTarget(self, action: #selector(RequestPlanViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.arrForPersons = ["1 Persons","2 Persons","3 Persons","4 Persons","5 Persons","6 Persons","7 Persons","8 Persons","9 Persons","10 Persons"]
         self.arrForDays = ["1 Night/2 Days","2 Nights/3 Days","3 Nights/4 Days","4 Nights/5 Days","5 Nights/6 Days","6 Nights/7 Days","7 Nights/8 Days","8 Nights/9 Days","9 Nights/10 Days","10 Nights/11 Days","11 Nights/12 Days","12 Nights/13 Days","13 Nights/14 Days","14 Nights/15 Days","More than 15 Days"]
         self.arrForBudgets = ["Economy","Standard","Luxury"]
        self.setDatePicker()
        personsPicker = UIPickerView()
        personsPicker.delegate = self
        personsPicker.backgroundColor = UIColor.lightGray
        self.txtfldNoOfPersons.inputView = personsPicker
        
        daysPicker = UIPickerView()
        daysPicker.delegate = self
        daysPicker.backgroundColor = UIColor.lightGray
        self.txtfldNoOfDays.inputView = daysPicker
        
        budgetPicker = UIPickerView()
        budgetPicker.delegate = self
        budgetPicker.backgroundColor = UIColor.lightGray
        self.txtfldBudget.inputView = budgetPicker
    }
    
    fileprivate func setDatePicker()
    {
        datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.lightGray
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(RequestPlanViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        txtfldDate.inputView = datePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        self.txtfldDate.text = dateFormatter.string(from: Date())
        isDaysValid = true
       
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        self.txtfldDate.text = dateFormatter.string(from: sender.date)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
        case self.txtfldCountry:
            self.isCountryValid = true
            self.validateForm()
            break
        case self.txtfldDepartureCity:
            self.isDepartureValid = true
            self.validateForm()
            break
        case self.txtfldArrivalCity:
            self.isArrivalValid = true
            self.validateForm()
            break
        case self.txtfldDate:
            self.isDateValid = true
            self.validateForm()
            break
        case self.txtfldNoOfPersons:
            self.isPersonsValid = true
            self.validateForm()
            break
        case self.txtfldNoOfDays:
            self.isDaysValid = true
            self.validateForm()
            break
        case self.txtfldBudget:
            self.isBudgetValid = true
            self.validateForm()
            break
        default:
            break
        }
        
    }
    
    fileprivate func validateForm() -> Bool {
        
        if (isCountryValid && isDepartureValid && isArrivalValid && isDateValid && isPersonsValid && isDaysValid && isBudgetValid)
        {
            self.btnRequest.isEnabled = true
            self.btnRequest.backgroundColor = UIColor.warmGrey()
            return true
        }
        self.btnRequest.isEnabled = false
        self.btnRequest.backgroundColor = UIColor.gray
        return false
    }
    
    
    //MARK: - UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == personsPicker {
            return self.arrForPersons.count
        }
        else if pickerView == daysPicker
        {
            return self.arrForDays.count
        }
        else
        {
            return self.arrForBudgets.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == personsPicker {
             return self.arrForPersons[row]
        }
        else if pickerView == daysPicker
        {
           return self.arrForDays[row]
        }
        else
        {
           return self.arrForBudgets[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == personsPicker {
            self.isPersonsValid = true
           self.txtfldNoOfPersons.text = self.arrForPersons[row]
        }
        else if pickerView == daysPicker
        {self.isDateValid = true
            self.txtfldNoOfDays.text = self.arrForDays[row]
        }
        else
        {
            self.isBudgetValid = true
            self.txtfldBudget.text = self.arrForBudgets[row]
        }
    }
    

    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRequestClicked(_ sender: Any) {
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.sendRequestForPLan((CurrentUser.sharedInstance.user?.name)!, email: (CurrentUser.sharedInstance.user?.email)!, phone: (CurrentUser.sharedInstance.user?.phone)!, country: self.txtfldCountry.text!, dep: self.txtfldDepartureCity.text!, arr: self.txtfldArrivalCity.text!, persons: self.txtfldNoOfPersons.text!, budget: self.txtfldBudget.text!, duration: self.txtfldNoOfDays.text!, agent_email: (CurrentUser.sharedInstance.user?.agentInfo.agent_email)!, subject: self.strSubject, image: self.strImage, handler: { (response,responseCode, error) in
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
                if responseCode == "0"
                {
                    self.showAlert("Oops !!", message: response!)
                }
                else
                {
                    
                    self.showAlert("Success !!", message: response!)
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
    
    
}
