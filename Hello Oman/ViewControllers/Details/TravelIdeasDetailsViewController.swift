//
//  TravelIdeasDetailsViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMobileAds
private let kTableHeaderHeight = 216.0
private let kReuseTableCellID = "reuseTableCellID"
class TravelIdeasDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate {


    var HeaderVIew: TravelItemsHeaderView!
    @IBOutlet weak var tblView: UITableView!
    var travelItems : TravelIdeasModel?
    var innerTravelItemsList = [DetailedTravelItemsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HeaderVIew = (Bundle.main.loadNibNamed("TravelItemsHeaderView", owner: self, options: nil)![0] as? TravelItemsHeaderView)
       
        HeaderVIew.bannerView.adUnitID = "ca-app-pub-7864413541660030/3123173782"
        HeaderVIew.bannerView.rootViewController = self
        HeaderVIew.bannerView.delegate = self
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        HeaderVIew.bannerView.load(request)
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 17)!]
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(TravelIdeasDetailsViewController.btnBackClicked(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item1
        self.navigationController?.navigationBar.isHidden = true
        
        let nibName = UINib(nibName: "MainTabelHeaderSectionView", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "MainTabelHeaderSectionView")
        
        self.tblView.register(UINib(nibName: "\(ListViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
        self.getAlltravelDetails(userId: (CurrentUser.sharedInstance.user?.id)!, agentId: (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!, travelId: (self.travelItems?.travelId)!)
        
        self.tblView.tableHeaderView = HeaderVIew
         self.upatingHeaderWithText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.tblView.contentSize.height = (self.tblView.contentSize.height - HeaderVIew.frame.size.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
       
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tblView.needsUpdateConstraints()
    }
    
    func updateHeaderView()  {
     
        var frame = CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height:CGFloat(kTableHeaderHeight))
        frame.origin.y = self.tblView.contentOffset.y
        if frame.origin.y <= 100 {
            frame.size.height = -self.tblView.contentOffset.y + CGFloat(kTableHeaderHeight)
            let viewHeight = frame.size.height + 200
            let viewFrame = CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: viewHeight)
         //   self.HeaderVIew.imgViewHeightConstrint.constant = frame.size.height
            self.HeaderVIew.frame = viewFrame
        }
    }
    
    func upatingHeaderWithText()
    {
        if let imageURL = URL(string: (travelItems?.travelImageUrl)!)
        {
            self.HeaderVIew.imgView.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        if self.travelItems?.travelIsFavourite == "1" {
            self.HeaderVIew.btnSave.isSelected = true
        }
        else
        {
            self.HeaderVIew.btnSave.isSelected = false
        }
        self.HeaderVIew.btnBack.addTarget(self, action: #selector(TravelIdeasDetailsViewController.btnBackClicked(_:)), for: .touchUpInside)
        
        self.HeaderVIew.btnShare.addTarget(self, action: #selector(TravelIdeasDetailsViewController.btnShareClicked(_:)), for: .touchUpInside)
        
        self.HeaderVIew.btnSave.addTarget(self, action: #selector(TravelIdeasDetailsViewController.btnSaveClicked(_:)), for: .touchUpInside)
        
        self.title = self.travelItems?.travelTitle
        self.HeaderVIew.lblHeaderTitle.text = self.travelItems?.travelTitle
        self.HeaderVIew.lblDesc.text = self.travelItems?.travelDesc
        
        
    }
    
    func getAlltravelDetails(userId : String, agentId : String, travelId : String) 
    {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAllDetailedTravelDetails(userId,agentId: agentId,travel_id: travelId, handler: { (allTravelDetails, error) in
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
                self.innerTravelItemsList = allTravelDetails!
                self.tblView.reloadData()
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblView.needsUpdateConstraints()
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {
        
        if let imageURL = NSURL(string: (travelItems?.travelImageUrl)!) {
            let request: NSURLRequest = NSURLRequest(url: imageURL as URL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
                // Handler
                if (error == nil && data != nil)
                {
                    func getImage() -> UIImage
                    {
                        return UIImage(data: data!)!
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = getImage()
                        
                        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                        self.present(shareVC, animated: true, completion: nil)
                    })
                }
            }
            
            task.resume()
        }
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        var isOption : String = ""
        if self.HeaderVIew.btnSave.isSelected {
            isOption = "1"
        }
        else
        {
             isOption = "0"
        }
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.UpdateFavoritedForTravelItems((CurrentUser.sharedInstance.user?.id)!,travel_id: (self.travelItems?.travelId)!,option:isOption , handler: { (response,responseCode, error) in
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
                    self.HeaderVIew.btnSave.isSelected = !self.HeaderVIew.btnSave.isSelected
                    //self.showAlert("Sucess !!", message: "")
                }
                else
                {
                    self.showAlert("Oops !!", message: "")
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
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.innerTravelItemsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 430.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "MainTabelHeaderSectionView" ) as! MainTabelHeaderSectionView
       
        let detaildObj = self.innerTravelItemsList[section]
        headerView.lblTitle.text = "\(section + 1)." + detaildObj.title
        headerView.lblDesc.text = detaildObj.desc
        if let imageURL = URL(string: (detaildObj.image))
        {
            headerView.imgView.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        return headerView
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let detaildObj = self.innerTravelItemsList[section]
        return detaildObj.packagesModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! ListViewTableViewCell
        
       let detaildObj = self.innerTravelItemsList[indexPath.section].packagesModelList
        let packgesObj = detaildObj[indexPath.row]
        
        if packgesObj.arrPackageImages.count > 0 {
            if let imageURL = URL(string: (packgesObj.arrPackageImages[0].image_URL))
            {
                cell.imgProfile.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
        }
        cell.leadingConstrint.constant = 10.0
        cell.trailingConstrint.constant = 10.0
        
        cell.lblTitle.text = packgesObj.packageTitle
        cell.lblDetail.text = packgesObj.packagePlaces
        let num = Int((packgesObj.packageDuration))
        cell.lblTimeDays.text = String(format:"\(num!) Days/\(num! - 1) Nights")
        let value = String(format: "OMR \((packgesObj.packagePrice))/head")
        cell.lblOMR.text = value
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detaildObj = self.innerTravelItemsList[indexPath.section].packagesModelList
        let packgesObj = detaildObj[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let detailPackgesVC: DetailsPackagesViewController = storyboard.instantiateViewController(withIdentifier: "DetailsPackagesViewController") as! DetailsPackagesViewController
        detailPackgesVC.packgesDetails = packgesObj
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(detailPackgesVC, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (velocity.y > 0)
        {
            self.navigationController?.navigationBar.isHidden = false
            self.HeaderVIew.btnBack.isHidden = true
        }
        if (velocity.y < 0)
        {
            self.navigationController?.navigationBar.isHidden = true
            self.HeaderVIew.btnBack.isHidden = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.updateHeaderView()
    }
    
    // Called when an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called when an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    // Called just before presenting the user a full screen view, such as a browser, in response to
    // clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just before dismissing a full screen view.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just after dismissing a full screen view.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just before the application will background or terminate because the user clicked on an
    // ad that will launch another application (such as the App Store).
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print(#function)
    }
    
}
