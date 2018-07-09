//
//  PackagesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
private let kReuseTableCellID = "reuseTableCellID"
private let kBtnMoreTag = 1300

protocol PackagesVCDelegate {
    func refreshStores(_ position: Int, animated : Bool)
}

class PackagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl?
    var delegate: PackagesVCDelegate?
    var packgesDetails : PackagesModelList?
    var totalCount : Int = 0
    var isContinuePagination : Bool = false
    var containerLandingVC: LandingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRefreshControl()
      
        self.tblView.register(UINib(nibName: "\(ListViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        // Do any additional setup after loading the view.
        self.isContinuePagination = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRefreshControl() {
        //Set refreshController
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(PackagesViewController.startRefresh), for: UIControlEvents.valueChanged)
        self.tblView.addSubview(refreshControl!)
        self.tblView.alwaysBounceVertical = true
        refreshControl?.endRefreshing()
    }
    
    
    @objc func startRefresh() {
        
        if let delegate = delegate {
            delegate.refreshStores(1, animated: false)
        }
    }
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.packgesDetails?.packagesModelList.count)!
        
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
        cell.btnCall.addTarget(self, action: #selector(PackagesViewController.btnCallClicked(sender:)), for: .touchUpInside)
        cell.btnPlan.tag = indexPath.row + 1
         cell.btnPlan.addTarget(self, action: #selector(PackagesViewController.btnForPlanClicked(sender:)), for: .touchUpInside)
        if(indexPath.row == ((self.packgesDetails!.packagesModelList.count) - 1))
        {
            if self.isContinuePagination == true {
                self.getPackagesDetails((CurrentUser.sharedInstance.user?.id)!, agentId: (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!, start: (self.packgesDetails!.packagesModelList.count))
            }
        }
        
        return cell
        
        
    }
    
    
    @objc func btnCallClicked(sender: AnyObject) {
        
        self.containerLandingVC?.callingAgentNum()
    }
    
    @objc func btnForPlanClicked(sender: AnyObject) {
        //RequestPlanViewController
         let modelObj = self.packgesDetails?.packagesModelList[(sender.tag - 1)]
        let imageObj = modelObj?.arrPackageImages[0]
        self.containerLandingVC?.gotoPlanRequestPage(subject: (modelObj?.packageTitle)!, image: (imageObj?.image_URL)!)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let modelObj = self.packgesDetails?.packagesModelList[indexPath.row]
        self.containerLandingVC?.gotoPakcgesDetailsViewController(packges: modelObj!)
    }
    
    func getPackagesDetails(_ userId : String, agentId : String, start: Int)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAllPackages(userId, agentId: agentId, start: start,  handler: { (response, error) in
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
                    
                    if self.packgesDetails?.packagesModelList.count == 0 {
                        
                        self.packgesDetails = packagesModelList
                        print("total: \(self.packgesDetails!.packagesModelList.count)")
                    }
                    else
                    {
                        if (packagesModelList.packagesModelList.count > 0)  {
                            
                            for index in 0 ..< Int((packagesModelList.packagesModelList.count)) {
                                
                                let item = packagesModelList.packagesModelList[index]
                                self.packgesDetails?.packagesModelList.append(item)
                            }
                            
                            print("total: \(self.packgesDetails!.packagesModelList.count)")
                            
                        }
                        else
                        {
                            self.isContinuePagination = false
                        }
                    }
                    self.tblView.reloadData()
                }
            }
        })
    }

}
