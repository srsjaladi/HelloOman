//
//  FilterPackgesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
private let kReuseTableCellID = "reuseTableCellID"
private let KButtonForTag = 50

class FilterPackgesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tblView: UITableView!
    var arrSort = [String]()
    var arrDuration = [String]()
    var arrBudget = [String]()
    var arrPrice = [String]()
    var arrTheme = [ThemeModel]()
    var arrType = [String]()
    var isClearClicked : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrSort = ["Lowest Price","Highest Price","Latest"]
        self.arrDuration = ["1 - 3 Days","4 - 7 Days ","8 - 14 Days","2 - 3 Weeks","3+ Weeks"]
        self.arrBudget = ["Economy","Standard","Luxury"]
        self.arrPrice = ["Less than 10000","10000 - 25000","25000 - 50000","More than 50000"]
        self.arrType = ["Domestic","International"]
        
        self.isClearClicked = false
        
        let nibName = UINib(nibName: "HomeSectionHeaderCReusableView", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "HomeSectionHeaderCReusableView")
        self.tblView.register(UINib(nibName: "\(SelectionTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
        self.getThemes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getThemes()  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getThemeDetails({ (themeList, error) in
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
                self.arrTheme = themeList!
                self.tblView.reloadData()
            }
        })
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }

    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCReusableView" ) as! HomeSectionHeaderCReusableView
        headerView.btnMore.isHidden = true
        headerView.btnForPlan.isHidden = true
        headerView.viewForContent.backgroundColor = UIColor.white
        headerView.lblDynamic.isHidden = true
        headerView.lblSideTitle.isHidden = false
        if section == 0
        {
            headerView.lblSideTitle.text = "Sort"
        }
        else if section == 1
        {
            headerView.lblSideTitle.text = "Duration"
        }
        else if section == 2
        {
            headerView.lblSideTitle.text = "Budget"
        }
        else if section == 3
        {
            headerView.lblSideTitle.text = "Price"
        }
        else if section == 4
        {
            headerView.lblSideTitle.text = "Theme"
        }
        else
        {
            headerView.lblSideTitle.text = "Type"
        }
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.arrSort.count
        }
        else if section == 1
        {
            return self.arrDuration.count
        }
        else if section == 2
        {
            return self.arrBudget.count
        }
        else if section == 3
        {
            return self.arrPrice.count
        }
        else if section == 4
        {
            return self.arrTheme.count
        }
        else
        {
            return self.arrType.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! SelectionTableViewCell
    
        if cell == nil {
            cell = SelectionTableViewCell(style:.default, reuseIdentifier: kReuseTableCellID)
        }
        
        switch indexPath.section {
        case 0:
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            cell.btnForSelect.setTitle(self.arrSort[indexPath.row], for: .normal)
            cell.btnForSelect.setTitle(self.arrSort[indexPath.row], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Radio"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "RadioSelected"), for: .selected)
             return cell
        case 1:
           
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            cell.btnForSelect.setTitle(self.arrDuration[indexPath.row], for: .normal)
            cell.btnForSelect.setTitle(self.arrDuration[indexPath.row], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
             return cell
        case 2:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            cell.btnForSelect.setTitle(self.arrBudget[indexPath.row], for: .normal)
            cell.btnForSelect.setTitle(self.arrBudget[indexPath.row], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
             return cell
        case 3:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            cell.btnForSelect.setTitle(self.arrPrice[indexPath.row], for: .normal)
            cell.btnForSelect.setTitle(self.arrPrice[indexPath.row], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
             return cell
        case 4:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            cell.btnForSelect.setTitle(self.arrTheme[indexPath.row].theme, for: .normal)
            cell.btnForSelect.setTitle(self.arrTheme[indexPath.row].theme, for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
             return cell
        case 5:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            cell.btnForSelect.setTitle(self.arrType[indexPath.row], for: .normal)
            cell.btnForSelect.setTitle(self.arrType[indexPath.row], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Radio"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "RadioSelected"), for: .selected)
             return cell
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! SelectionTableViewCell
              return cell
            
        }

    }
    
    
    @objc func selectedStringClicked(sender: AnyObject) {
       
        print(sender.tag)
        if let btnColor = self.view.viewWithTag(sender.tag) as? UIButton {
            btnColor.isSelected = !btnColor.isSelected
        }
        print(sender.tag/KButtonForTag)
        switch (sender.tag/KButtonForTag)  {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnClearClicked(_ sender: Any) {
        self.isClearClicked = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
