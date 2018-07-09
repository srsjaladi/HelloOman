//
//  MorePackagesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
private let kReuseTableCellID = "reuseTableCellID"
private let kBtnMoreTag = 1700

class MorePackagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tblView: UITableView!
   var packgesDetails : PackagesModelList?
    var strTitle : String = ""
    var agentId : String = ""
    var userId : String = ""
    var type: String = "0"
    var search : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
         self.tblView.register(UINib(nibName: "\(ListViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
        self.title = strTitle
        
        self.getListofMorePackages(userID: self.userId, agentId: self.agentId, type: self.type,search: self.search)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if packgesDetails != nil {
            if ((self.packgesDetails?.packagesModelList.count)! > 0) {
                return (self.packgesDetails?.packagesModelList.count)!
            }
            else
            {
                return 0
            }
        }
        else
        {
             return 0
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! ListViewTableViewCell
        
        let modelObj = self.packgesDetails?.packagesModelList[indexPath.row]
        if (modelObj?.arrPackageImages.count)! > 0 {
            let imageObj = modelObj?.arrPackageImages[0]
            if let imageURL = URL(string: (imageObj?.image_URL)!)
            {
                cell.imgProfile.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
        }
        else
        {
            cell.imgProfile.image = UIImage(named: "DefaultImage")
        }
        
        cell.lblTitle.text = modelObj?.packageTitle
        cell.lblDetail.text = modelObj?.packagePlaces
        let num = Int((modelObj?.packageDuration)!)
        cell.lblTimeDays.text = String(format:"\(num!) Days/\(num! - 1) Nights")
        let value = String(format: "OMR \((modelObj?.packagePrice)!)/head")
        cell.lblOMR.text = value
        cell.btnCall.addTarget(self, action: #selector(MorePackagesViewController.btnCallClicked(sender:)), for: .touchUpInside)
        cell.btnPlan.tag = indexPath.row + 1
        cell.btnPlan.addTarget(self, action: #selector(MorePackagesViewController.btnForPlanClicked(sender:)), for: .touchUpInside)
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelObj = self.packgesDetails?.packagesModelList[indexPath.row]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let detailPackgesVC: DetailsPackagesViewController = storyboard.instantiateViewController(withIdentifier: "DetailsPackagesViewController") as! DetailsPackagesViewController
        detailPackgesVC.packgesDetails = modelObj
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(detailPackgesVC, animated: true)
    }
    
    @objc func btnCallClicked(sender: AnyObject) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let agentDetailsVC = homeStoryboard.instantiateViewController(withIdentifier: "CallToAgentViewController") as! CallToAgentViewController
        self.present(agentDetailsVC, animated: false, completion: nil)
    }
    
    @objc func btnForPlanClicked(sender: AnyObject) {
        //RequestPlanViewController
        let modelObj = self.packgesDetails?.packagesModelList[(sender.tag - 1)]
        let imageObj = modelObj?.arrPackageImages[0]
      
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let requestPlanVC: RequestPlanViewController = storyboard.instantiateViewController(withIdentifier: "RequestPlanViewController") as! RequestPlanViewController
        requestPlanVC.strImage = (modelObj?.packageTitle)!
        requestPlanVC.strSubject = (imageObj?.image_URL)!
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(requestPlanVC, animated: true)
        
    }
    
    
    func getListofMorePackages(userID : String, agentId:String, type:String,search: String)  {
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAllPackagesFromMore(userID, agentId: agentId, type: type,search:search, handler: { (response, error) in
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
                    self.packgesDetails = packagesModelList
                    print("total: \(self.packgesDetails!.packagesModelList.count)")
                }
                self.tblView.reloadData()
            }
        })
        
    }
    
   

}
