//
//  DetailsPackagesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMobileAds
import MWPhotoBrowser

private let kReuseTableCellID = "reuseTableCellID"
private let kReuseDetailTableCellID = "reuseDetailTableCellID"
private let kReuseCollectionCellID = "reuseCollectionCellID"
private let kReuseSmallCollectionCellID = "reuseSmallCollectionCellID"
private let kTagCollectionView = 1900

class DetailsPackagesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate,MWPhotoBrowserDelegate{
    
 

    @IBOutlet weak var headerView: PackagesHeaderView!
    @IBOutlet weak var tblView: UITableView!
 
    var packgesDetails : PackagesModel?
    var arrItineraryList = [ItineraryModel]()
    var photos = [MWPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = (Bundle.main.loadNibNamed("PackagesHeaderView", owner: self, options: nil)![0] as? PackagesHeaderView)
        
       headerView.bannerView.adUnitID = "ca-app-pub-7864413541660030/3123173782"
        headerView.bannerView.rootViewController = self
        headerView.bannerView.delegate = self
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        headerView.bannerView.load(request)
       // bannerView.load(GADRequest())
        self.title = packgesDetails?.packageTitle
        self.automaticallyAdjustsScrollViewInsets = true
        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "HomeSectionHeaderCReusableView", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "HomeSectionHeaderCReusableView")
        
        self.tblView.register(UINib(nibName: "\(CollectionViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseCollectionCellID)
        
        self.tblView.register(UINib(nibName: "\(ItineraryTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseDetailTableCellID)
        
          self.tblView.register(UINib(nibName: "\(InclusionsTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
        self.getItineraryDetials(pakcgeId: (self.packgesDetails?.packageId)!)
        self.tblView.tableHeaderView = self.headerView
        self.headerView.btnCar.isHidden = true
        self.headerView.btnFood.isHidden = true
        self.headerView.btnPlan.isHidden = true
        self.headerView.btnTrain.isHidden = true
        self.headerView.btnSightSeeing.isHidden = true
        self.UpdateHeader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.warmGrey()]
      
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tblView.needsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getItineraryDetials(pakcgeId: String)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getItineraryDetails(pakcgeId, handler: { (allItineraryDetails, error) in
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
                self.arrItineraryList = allItineraryDetails!
                self.tblView.reloadData()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblView.needsUpdateConstraints()
    }

    @IBAction func btnSaveClicked(_ sender: Any) {
        
        var isOption : String = ""
        if self.headerView.btnSave.isSelected {
            isOption = "1"
        }
        else
        {
            isOption = "0"
        }
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.UpdateFavoritedForPackages((CurrentUser.sharedInstance.user?.id)!,package_id: (self.packgesDetails?.packageId)!,option:isOption , handler: { (response,responseCode, error) in
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
                     self.headerView.btnSave.isSelected = !self.headerView.btnSave.isSelected
                   // self.showAlert("Sucess !!", message: "")
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
    
    @IBAction func btnShareClicked(_ sender: Any) {
        
        if let imageURL = NSURL(string: (packgesDetails?.arrPackageImages[0].image_URL)!) {
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
    
    func UpdateHeader()  {
        
        self.headerView.btnShare.addTarget(self, action: #selector(DetailsPackagesViewController.btnShareClicked(_:)), for: .touchUpInside)
        
        self.headerView.btnSave.addTarget(self, action: #selector(DetailsPackagesViewController.btnSaveClicked(_:)), for: .touchUpInside)
        
        if (packgesDetails?.arrPackageImages.count)! > 0 {
            if let imageURL = URL(string: (packgesDetails?.arrPackageImages[0].image_URL)!)
            {
                self.headerView.imageView.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
        }
        
        if self.packgesDetails?.packageFav == "1" {
            self.headerView.btnSave.isSelected = true
        }
        else
        {
            self.headerView.btnSave.isSelected = false
        }
       
        let stringType = self.packgesDetails?.packageInclusions
        let arrayTypes = stringType?.split(separator: ",")
        print(arrayTypes!)
        for item in arrayTypes!
        {
            switch String(item) {
            case "Food":
                self.headerView.btnFood.isHidden = false
                break
            case " food","food":
                self.headerView.btnFood.isHidden = false
                break
            case "Flight":
                self.headerView.btnPlan.isHidden = false
                break
            case "Pickup":
                self.headerView.btnCar.isHidden = false
                break
            case "Sightseeing":
                self.headerView.btnSightSeeing.isHidden = false
                break
            case "Train":
                self.headerView.btnTrain.isHidden = false
                break
            case " Train":
                self.headerView.btnTrain.isHidden = false
                break
            default:
                break
            }
        }
        
        
        let string = self.packgesDetails?.packagePlaces
        let array = string?.split(separator: ",")
        print(array!)
        var strCity : String = ""
        for item in array!
        {
            
            if strCity == ""
            {
                strCity = String(item)
            }
            else
            {
                strCity = strCity + " -> " + item
            }
        }
        self.headerView.lblTitle.text = self.packgesDetails?.packageTitle
        let numDuration = Int((self.packgesDetails?.packageDuration)!)
        self.headerView.lblOMR.text = String(format: "OMR \(self.packgesDetails!.packagePrice)/head")
        self.headerView.lblDaysNights.text = String(format: "\(numDuration!) days/\(numDuration! - 1) Nights")
        self.headerView.lblDetailLocation.text = strCity
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section ==  0)
        {
            return  54.0
        }
        else if (indexPath.section == 1)
        {
            return 170.0
        }
        else
        {
            return 44.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.arrItineraryList.count
        }
        else if section == 1
        {
            if (self.packgesDetails?.arrPackageImages.count)! > 0
            {
               return 1
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            if (self.packgesDetails?.packageInclusions)!  != ""
            {
                return 1
            }
            else
            {
                return 0
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
         return 40.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCReusableView" ) as! HomeSectionHeaderCReusableView
        headerView.btnMore.isHidden = true
        headerView.btnForPlan.isHidden = true
        headerView.viewForContent.backgroundColor = UIColor.clear
        headerView.lblDynamic.isHidden = true
        headerView.lblSideTitle.isHidden = false
        if section == 0
        {
             headerView.lblSideTitle.text = "Itinerary"
        }
        else if section == 1
        {
             headerView.lblSideTitle.text = "Photos"
        }
        else
        {
             headerView.lblSideTitle.text = "Inclusions"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: kReuseCollectionCellID, for: indexPath) as! CollectionViewTableViewCell
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: kTagCollectionView)
            cell.collectionViewOffset = 0
            
            return cell
        }
        else if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: kReuseDetailTableCellID, for: indexPath) as! ItineraryTableViewCell
          
            let itineraryModel = self.arrItineraryList[indexPath.row]
            
            cell.lblTitle.text = itineraryModel.Itinerary_title
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! InclusionsTableViewCell
            
            cell.lblInclusions.text = self.packgesDetails?.packageInclusions
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if indexPath.section == 0
        {
           
            let itineraryModel = self.arrItineraryList[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let requestPlanVC: ItineraryViewController = storyboard.instantiateViewController(withIdentifier: "ItineraryViewController") as! ItineraryViewController
            requestPlanVC.strTitle = itineraryModel.Itinerary_title
            requestPlanVC.strDesc = itineraryModel.Itinerary_desc
            self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
            self.navigationController?.pushViewController(requestPlanVC, animated: true)
            
        }
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return photos[Int(index)] as MWPhoto
    }

    
    func photoAtIndex(index: Int, photoBrowser: MWPhotoBrowser) -> MWPhoto? {
        if index < photos.count {
            return photos[index]
        }
        return nil
    }
    
    
    @IBAction func btnCallClicked(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let agentDetailsVC = homeStoryboard.instantiateViewController(withIdentifier: "CallToAgentViewController") as! CallToAgentViewController
        self.present(agentDetailsVC, animated: false, completion: nil)

    }
    
    @IBAction func btnPlanClicked(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let reqVC: RequestPlanViewController = homeStoryboard.instantiateViewController(withIdentifier: "RequestPlanViewController") as! RequestPlanViewController
        reqVC.strSubject = (self.packgesDetails?.packageTitle)!
        reqVC.strImage = (self.packgesDetails?.arrPackageImages[0].image_URL)!
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(reqVC, animated: true)
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

extension DetailsPackagesViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    
    
    // MARK: - CollectionView Protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.packgesDetails?.arrPackageImages.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseSmallCollectionCellID, for: indexPath) as! SmallCollectionViewCell
        
        let imgObject = self.packgesDetails?.arrPackageImages[indexPath.row]
        
        if let imageURL = URL(string: (imgObject!.image_URL))
        {
            cell.imageTitle.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        cell.lblTitle.isHidden = true
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        self.photos.removeAll()
        // Add photos
        if (self.packgesDetails?.arrPackageImages.count)! > 0
        {
            for i in 0 ... ((self.packgesDetails?.arrPackageImages.count)! - 1)
            {
                let imgObject = self.packgesDetails?.arrPackageImages[i]
                photos.append(MWPhoto(url: NSURL(string: (imgObject?.image_URL)!)! as URL))
            }
        }
       
        let browser = MWPhotoBrowser(delegate: self)
        
        // Set options
        browser?.displayActionButton = true
        browser?.displayNavArrows = false
        browser?.displaySelectionButtons = false
        browser?.zoomPhotosToFill = false
        browser?.alwaysShowControls = false
        browser?.enableGrid = true
        browser?.startOnGrid = false
        browser?.autoPlayOnAppear = false
        browser?.customImageSelectedIconName = "ImageSelected.png"
        browser?.customImageSelectedSmallIconName = "ImageSelectedSmall.png"
        
        
        self.navigationController?.pushViewController(browser!, animated: true)
        
        // Manipulate
        browser?.showNextPhoto(animated: true)
        browser?.showPreviousPhoto(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 230.0 , height: 150.0)
        
    }
    

    
}
