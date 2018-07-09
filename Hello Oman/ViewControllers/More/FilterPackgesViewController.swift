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
    var arrSort = [[String:String]]()
    var arrDuration = [[String:String]]()
    var arrBudget = [[String:String]]()
    var arrPrice = [[String:String]]()
    var arrTheme = [ThemeModel]()
    var arrOriginalTheme = [ThemeModel]()
    var arrType = [[String:String]]()
    var isClearClicked : Bool = false
    var search : String = ""
    var type: String = ""
    
    
    var isSort : String = ""
    var isDuration : String = ""
    var isBudget : String = ""
    var isPrice : String = ""
    var isTheme : String = ""
    var isType : String = ""
    
    var sortFilter : String = ""
    var days1 : String = ""
    var days2 : String = ""
    var days3 : String = ""
    var days4 : String = ""
    var days5 : String = ""
    var budget1 : String = ""
    var budget2 : String = ""
    var budget3 : String = ""
    var price1 : String = ""
    var price2 : String = ""
    var price3 : String = ""
    var price4 : String = ""
    var themeFilter : String = ""
    var typeFilter : String = ""
    
    var mainFilter : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrSort = [["name":"Lowest Price","Selected":"false"],[ "name": "Highest Price","Selected":"false"],[ "name": "Latest","Selected":"false"]]
        
        self.arrDuration = [["name":"1 - 3 Days","Selected":"false"],[ "name": "4 - 7 Days ","Selected":"false"],[ "name": "8 - 14 Days","Selected":"false"],[ "name": "2 - 3 Weeks","Selected":"false"],[ "name": "3+ Weeks","Selected":"false"]]
        
         self.arrBudget = [["name":"Economy","Selected":"false"],[ "name": "Standard","Selected":"false"],[ "name": "Luxury","Selected":"false"]]
        
         self.arrPrice = [["name":"Less than 10000","Selected":"false"],[ "name": "10000 - 25000","Selected":"false"],[ "name": "25000 - 50000","Selected":"false"],[ "name": "More than 50000","Selected":"false"]]
        
         self.arrType = [["name":"Domestic","Selected":"false"],[ "name": "International","Selected":"false"]]
    
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
                self.arrOriginalTheme = themeList!
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! SelectionTableViewCell
    
        switch indexPath.section {
        case 0:
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            let strObj = self.arrSort[indexPath.row] as [String:String]
            
            cell.btnForSelect.setTitle(strObj["name"], for: .normal)
            cell.btnForSelect.setTitle(strObj["name"], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Radio"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "RadioSelected"), for: .selected)
            
            if (strObj["Selected"] == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
            
             return cell
        case 1:
           
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
             let strObj = self.arrDuration[indexPath.row] as [String:String]
            
            cell.btnForSelect.setTitle(strObj["name"], for: .normal)
            cell.btnForSelect.setTitle(strObj["name"], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
            
            if (strObj["Selected"] == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
             return cell
        case 2:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            let strObj = self.arrBudget[indexPath.row] as [String:String]
            
            cell.btnForSelect.setTitle(strObj["name"], for: .normal)
            cell.btnForSelect.setTitle(strObj["name"], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
            if (strObj["Selected"] == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
             return cell
        case 3:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            let strObj = self.arrPrice[indexPath.row] as [String:String]

            cell.btnForSelect.setTitle(strObj["name"], for: .normal)
            cell.btnForSelect.setTitle(strObj["name"], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
            if (strObj["Selected"] == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
             return cell
        case 4:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            cell.btnForSelect.setTitle(self.arrTheme[indexPath.row].theme, for: .normal)
            cell.btnForSelect.setTitle(self.arrTheme[indexPath.row].theme, for: .selected)
            
            
            cell.btnForSelect.setImage(UIImage(named: "Checkmark"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "ChemarkChecked"), for: .selected)
            if (self.arrTheme[indexPath.row].selected == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
             return cell
        case 5:
            
            cell.btnForSelect.tag = ((KButtonForTag * indexPath.section) + indexPath.row + 1)
            cell.btnForSelect.addTarget(self, action: #selector(FilterPackgesViewController.selectedStringClicked(sender:)), for: .touchUpInside)
            
            let strObj = self.arrType[indexPath.row] as [String:String]
            
            cell.btnForSelect.setTitle(strObj["name"], for: .normal)
            cell.btnForSelect.setTitle(strObj["name"], for: .selected)
            cell.btnForSelect.setImage(UIImage(named: "Radio"), for: .normal)
            cell.btnForSelect.setImage(UIImage(named: "RadioSelected"), for: .selected)
            if (strObj["Selected"] == "false")
            {
                cell.btnForSelect.isSelected = false
            }
            else
            {
                cell.btnForSelect.isSelected = true
            }
             return cell
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! SelectionTableViewCell
              return cell
            
        }

    }
    
    
    @objc func selectedStringClicked(sender: AnyObject) {
       
        print(sender.tag)
        let btnColor = self.view.viewWithTag(sender.tag) as? UIButton
        btnColor?.isSelected = !(btnColor?.isSelected)!
        
        print(sender.tag/KButtonForTag)
        switch (sender.tag/KButtonForTag)  {
        case 0:
            switch (sender.tag%KButtonForTag - 1)
            {
            case 0:
                sortFilter = " order by package_price asc"
                break
            case 1:
                sortFilter = " order by package_price desc"
                break
            case 2:
                sortFilter = " order by package_id desc"
                break
            default :
                break
            }
            
             if (btnColor?.isSelected)!
             {
                self.arrSort[sender.tag%KButtonForTag - 1]["Selected"] = "true"
             }
             else
             {
                self.arrSort[sender.tag%KButtonForTag - 1]["Selected"] = "false"
             }

             for i in (0 ... self.arrType.count - 1)
             {
                if self.arrSort[i]["name"] != btnColor?.titleLabel?.text
                {
                    self.arrSort[i]["Selected"] = "false"
                }
                
             }
             self.tblView.reloadData()
            break
        case 1:
            switch (sender.tag%KButtonForTag - 1)
            {
            case 0:
                 days1 = "(package_days >= 1 and package_days <= 3)"
                break
            case 1:
                days2 = "(package_days >= 4 and package_days <= 7)"
                break
            case 2:
                days3 = "(package_days >= 8 and package_days <= 14)"
                break
            case 3:
                days4 = "(package_days >= 14 and package_days <= 21)"
                break
            case 4:
                days5 = "(package_days >= 21)"
                break
            default :
                break
            }
            if (btnColor?.isSelected)!
            {
                self.arrDuration[sender.tag%KButtonForTag - 1]["Selected"] = "true"
            }
            else
            {
                self.arrDuration[sender.tag%KButtonForTag - 1]["Selected"] = "false"
            }
            break
        case 2:
            
            switch (sender.tag%KButtonForTag - 1)
            {
            case 0:
                budget1 = "(package_budget = 'Economy')"
                break
            case 1:
                 budget2 = "(package_budget = 'Standard')"
                break
            case 2:
                budget3 = "(package_budget = 'Luxury')"
                break
            default :
                break
            }
            
            if (btnColor?.isSelected)!
            {
                self.arrBudget[sender.tag%KButtonForTag - 1]["Selected"] = "true"
            }
            else
            {
                self.arrBudget[sender.tag%KButtonForTag - 1]["Selected"] = "false"
            }
            break
        case 3:
            
            switch (sender.tag%KButtonForTag - 1)
            {
            case 0:
                price1 = "(package_price <= 10000)"
                break
            case 1:
                price2 = "(package_price >= 10000 and package_price <= 25000)"
                break
            case 2:
                price3 = "(package_price >= 25000 and package_price <= 50000)"
                break
            case 3:
                price4 = "(package_price >= 50000)"
                break
            default :
                break
            }
            
            if (btnColor?.isSelected)!
            {
                self.arrPrice[sender.tag%KButtonForTag - 1]["Selected"] = "true"
            }
            else
            {
                self.arrPrice[sender.tag%KButtonForTag - 1]["Selected"] = "false"
            }
            break
        case 4:
            
            if (btnColor?.isSelected)!
            {
                self.arrTheme[sender.tag%KButtonForTag - 1].selected = "true"
            }
            else
            {
                self.arrTheme[sender.tag%KButtonForTag - 1].selected = "false"
            }
            break
        case 5:
            
            switch (sender.tag%KButtonForTag - 1)
            {
                
            case 0:
                typeFilter = " and package_type = 1 "
                break
            case 1:
                typeFilter = " and package_type = 2 "
                break
            default :
                break
            }
            if (btnColor?.isSelected)!
            {
                self.arrType[sender.tag%KButtonForTag - 1]["Selected"] = "true"
            }
            else
            {
                self.arrType[sender.tag%KButtonForTag - 1]["Selected"] = "false"
            }
            
            for i in (0 ... self.arrType.count - 1)
            {
                if self.arrType[i]["name"] != btnColor?.titleLabel?.text
                {
                    self.arrType[i]["Selected"] = "false"
                }
                
            }
            self.tblView.reloadData()
            
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        
        isSort = sortFilter

        isDuration = String(format: "and ( \(days1 + "or" + days2 + "or" + days3 + "or" + days4 + "or" + days5) )")
        
        if let range = isDuration.range(of: "orororor") {
            isDuration.removeSubrange(range)
        }
        if let range = isDuration.range(of: "ororor") {
            isDuration.removeSubrange(range)
        }
        if let range = isDuration.range(of: "oror") {
            isDuration.removeSubrange(range)
        }
       
        isBudget = String(format: "and ( \(budget1 + "or" + budget2 + "or" + budget3) )")
       
        if let range = isBudget.range(of: "oror") {
            isBudget.removeSubrange(range)
        }
        
        isPrice = String(format: "and ( \(price1 + "or" + price2 + "or" + price3 + "or" + price4) )")
        
        if let range = isPrice.range(of: "orororor") {
            isPrice.removeSubrange(range)
        }
        if let range = isPrice.range(of: "ororor") {
            isPrice.removeSubrange(range)
        }
       
        themeFilter = ""
        for i in 0 ... (self.arrTheme.count - 1)
        {
            if self.arrTheme[i].selected == "true"
            {
                if themeFilter == ""
                {
                    themeFilter =  "and (package_theme = '\(self.arrTheme[i].theme)')"
                }
                else
                {
                    themeFilter = themeFilter + "and (package_theme = '\(self.arrTheme[i].theme)')"
                }
            }
        }
        
        
        isTheme = themeFilter
        isType = typeFilter
        
        var strSubStringOne = ""
        var strSubStringTwo = ""
    
        if isDuration != "and (  )"
        {
            strSubStringOne = isDuration
        }
        
        if isBudget  != "and (  )"
        {
            strSubStringOne = strSubStringOne + isBudget
        }
        
        if isPrice != "and (  )" {
            strSubStringTwo = isPrice
        }
        
         strSubStringTwo =  isTheme  + isType
        
        mainFilter =  strSubStringOne + strSubStringTwo + isSort
        
        print(mainFilter)
        
        if (self.search == "" && self.type == "")
        {
            self.FromPackage ()
        }
        else
        {
            self.fromOtherScreen()
        }
        
    }
    
    
    func FromPackage()  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAllFilterPackages((CurrentUser.sharedInstance.user?.id)!, agentId: (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!, filters: mainFilter, handler: { (response, error) in
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
                if let packagesModelList = response as? PackagesModelList {
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let filterResultsVC: FilterResultsViewController = storyboard.instantiateViewController(withIdentifier: "FilterResultsViewController") as! FilterResultsViewController
                    filterResultsVC.packgesDetails = packagesModelList
                    self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
                    self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
                    self.navigationController?.pushViewController(filterResultsVC, animated: true)
                    
                }
            }
        })
    }
    
    
   func fromOtherScreen()
   {
    
    MBProgressHUD.showHUDAddedGlobal()
    HelloOmanAPI.sharedInstance.getAllSearchFilterPackages((CurrentUser.sharedInstance.user?.id)!, agentId: (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!,search: self.search,
                                                           type : self.type, filters: mainFilter, handler: { (response, error) in
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
            if let packagesModelList = response as? PackagesModelList {
                
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let filterResultsVC: FilterResultsViewController = storyboard.instantiateViewController(withIdentifier: "FilterResultsViewController") as! FilterResultsViewController
                filterResultsVC.packgesDetails = packagesModelList
                self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
                self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.pushViewController(filterResultsVC, animated: true)
                
            }
        }
    })
    
    }
    
    @IBAction func btnClearClicked(_ sender: Any) {
        self.isClearClicked = true
        self.arrSort = [["name":"Lowest Price","Selected":"false"],[ "name": "Highest Price","Selected":"false"],[ "name": "Latest","Selected":"false"]]
        
        self.arrDuration = [["name":"1 - 3 Days","Selected":"false"],[ "name": "4 - 7 Days ","Selected":"false"],[ "name": "8 - 14 Days","Selected":"false"],[ "name": "2 - 3 Weeks","Selected":"false"],[ "name": "3+ Weeks","Selected":"false"]]
        
        self.arrBudget = [["name":"Economy","Selected":"false"],[ "name": "Standard","Selected":"false"],[ "name": "Luxury","Selected":"false"]]
        
        self.arrPrice = [["name":"Less than 10000","Selected":"false"],[ "name": "10000 - 25000","Selected":"false"],[ "name": "25000 - 50000","Selected":"false"],[ "name": "More than 50000","Selected":"false"]]
        
        self.arrType = [["name":"Domestic","Selected":"false"],[ "name": "International","Selected":"false"]]
        
        self.arrTheme =  self.arrOriginalTheme
        
        self.isSort  = ""
        self.isDuration  = ""
        self.isBudget  = ""
        self.isPrice  = ""
        self.isTheme  = ""
        self.isType  = ""
        
        self.sortFilter  = ""
        self.days1  = ""
        self.days2  = ""
        self.days3  = ""
        self.days4  = ""
        self.days5  = ""
        self.budget1  = ""
        self.budget2  = ""
        self.budget3  = ""
        self.price1  = ""
        self.price2  = ""
        self.price3  = ""
        self.price4  = ""
        self.themeFilter  = ""
        self.typeFilter  = ""
        self.mainFilter = ""
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
