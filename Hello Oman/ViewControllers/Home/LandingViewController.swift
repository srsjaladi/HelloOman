//
//  LandingViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
import GooglePlaces


class LandingViewController: UIViewController,CAPSPageMenuDelegate,HomeVCDelegate,PackagesVCDelegate,TravelPlansVCDelegate {

    @IBOutlet weak var btnFilterImgView: UIImageView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    var pageMenu: CAPSPageMenu?
    let pageMenuTag: Int = 100
    var selectedPageIndex: Int = 0
    var totalCount : Int = 0
    var positionPage : Int = 0
    var homeDetails : HomeModel?
    var packgesDetails : PackagesModelList?
    var travelPlansList = [CategoryModel]()
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var btnContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.btnFilterImgView.cornerRadius = self.btnFilterImgView.frame.width/2
        self.btnFilterImgView.clipsToBounds = true
        self.btnFilter.isHidden = true
        self.btnFilterImgView.backgroundColor = UIColor.clear
        
        let img = UIImage(named: "TabBarImg")

        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        if let userID = (CurrentUser.sharedInstance.user?.id), let agentId = (CurrentUser.sharedInstance.user?.agentInfo.agent_id) {
            self.getHomeDetails(userID,agentId: agentId,start: 0)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let img = UIImage(named: "TabBarImg")
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func refreshStores(_ position: Int, animated : Bool) {
        
        DispatchQueue.main.async {
            if let userID = (CurrentUser.sharedInstance.user?.id), let agentId = (CurrentUser.sharedInstance.user?.agentInfo.agent_id) {
                self.getHomeDetails(userID,agentId: agentId,start: 0)
            }
        }
        
    }
    
    func getHomeDetails(_ userId : String,agentId : String, start: Int)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getHomeDetails(userId, handler: { (homeDetails, error) in
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
                self.homeDetails = homeDetails
                self.getPackagesDetails(userId,agentId:agentId, start:start)
            }
        })
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
                let packagesModelList = response as? PackagesModelList
                self.packgesDetails = packagesModelList
                self.getTravelPLans(userId: (CurrentUser.sharedInstance.user?.id)!)
            }
        })
    }
    
    func getTravelPLans(userId: String)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getTravelPlansDetails(user_id: userId, handler: { (allTravelPlanDetails, error) in
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
                let travelPlansList = allTravelPlanDetails as [CategoryModel]
                self.travelPlansList = travelPlansList
                self.buildPageMenu(self.positionPage, animated: true)
            }
        })
    }
    
    fileprivate func buildPageMenu(_ position: Int, animated : Bool)
    {
        // Remove ex pageMenus
        if let exPageMenu = self.view.viewWithTag(pageMenuTag) {
            exPageMenu.removeFromSuperview()
        }
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        // Reverse order of store to show parent store first
        // self.storeList = self.storeList.reverse()
        var itemCount = 0
        // Adding the search screen
        
        let homeVC: HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.title = "HOME"
        homeVC.delegate = self
        homeVC.containerLandingVC = self
        homeVC.homeDetails = self.homeDetails
        controllerArray.append(homeVC)
        itemCount += 1
        
        let packagesVC: PackagesViewController = storyboard.instantiateViewController(withIdentifier: "PackagesViewController") as! PackagesViewController
        packagesVC.title = "PACKAGES"
        packagesVC.packgesDetails = self.packgesDetails
        packagesVC.containerLandingVC = self
        packagesVC.delegate = self
        controllerArray.append(packagesVC)
        itemCount += 1
        
        let trvlPlansVC: TravelPlansViewController = storyboard.instantiateViewController(withIdentifier: "TravelPlansViewController") as! TravelPlansViewController
        trvlPlansVC.title = "TRAVEL PLANS"
        trvlPlansVC.travelPlansList = self.travelPlansList
        trvlPlansVC.delegate = self
        trvlPlansVC.containerLandingVC = self
        controllerArray.append(trvlPlansVC)
        itemCount += 1
        
        totalCount = itemCount
        
        //Customize PageMenu
        let parameters: [CAPSPageMenuOption] = [
            CAPSPageMenuOption.menuMargin(0),
            CAPSPageMenuOption.useMenuLikeSegmentedControl(false),
            .menuHeight(40.0),
            .selectionIndicatorHeight(4.0),
            .scrollMenuBackgroundColor(UIColor.warmGrey()),
            .viewBackgroundColor(UIColor.warmGrey()),
            .selectionIndicatorColor(UIColor.sandyBrownColor()),
            .menuItemFont(UIFont.dinProRegular(16)),
            .selectedMenuItemLabelColor(UIColor.sandyBrownColor()),
            .unselectedMenuItemLabelColor(UIColor.white),
            .addBottomMenuHairline(false),
            CAPSPageMenuOption.scrollAnimationDurationOnMenuItemTap(300),
            .menuItemWidth(self.getMenuItemWidth(itemCount)),
            .menuItemSeparatorColor(UIColor.clear),
            .menuItemWidthBasedOnTitleTextWidth((itemCount) > 3),
            .enableHorizontalBounce(false)
        ]
        
        // Initialize page menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-50), pageMenuOptions: parameters, isFromBrand: false)
        pageMenu!.view.tag = pageMenuTag
        pageMenu?.delegate = self
        self.pageMenu?.controllerScrollView.isPagingEnabled = true
        self.view.addSubview(pageMenu!.view)
        self.addPriorityToMenuGesuture(pageMenu!.controllerScrollView)
        self.pageMenu?.moveToPage(position, animated: animated)
       
        
    }
    
    fileprivate func getMenuItemWidth(_ items: Int) -> CGFloat{
        if (items <= 3) {
            return self.view.frame.width / CGFloat(items)
        }
        else {
            return (self.view.frame.width * 0.9) / 3
        }
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
       
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 1
        {
            self.btnFilter.isHidden = false
            self.btnFilterImgView.backgroundColor = UIColor.oldPinkColor()
        }
        else
        {
            self.btnFilter.isHidden = true
            self.btnFilterImgView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        self.openLeft()
    }
    
    @IBAction func btnSavedClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let favouritesVC: FavouritesViewController = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        favouritesVC.positionPage = 0
        favouritesVC.isfromMain = false
       self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(favouritesVC, animated: true)
    }
    
    @IBAction func btnSearchClicked(_ sender: Any) {
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self as GMSAutocompleteViewControllerDelegate
        present(placePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnFilterClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let FilterPackgesVC: FilterPackgesViewController = storyboard.instantiateViewController(withIdentifier: "FilterPackgesViewController") as! FilterPackgesViewController
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(FilterPackgesVC, animated: true)
    }
    func gotoPlanRequestPage(subject : String , image: String)  {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let reqVC: RequestPlanViewController = homeStoryboard.instantiateViewController(withIdentifier: "RequestPlanViewController") as! RequestPlanViewController
        reqVC.strSubject = subject
        reqVC.strImage = image
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(reqVC, animated: true)
    }
    
    
    func gotoPackgesViewController(type : String, search: String, title : String)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let morePackgesVC: MorePackagesViewController = storyboard.instantiateViewController(withIdentifier: "MorePackagesViewController") as! MorePackagesViewController
        morePackgesVC.agentId = (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!
        morePackgesVC.userId = (CurrentUser.sharedInstance.user?.id)!
        morePackgesVC.type = type
        morePackgesVC.search = search
        morePackgesVC.strTitle = title
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(morePackgesVC, animated: true)
    }
    
    func gotoTravelIdeasViewController(categoryId : String, title : String)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let moreTravelIdeaVC: MoreTravelIdeasViewController = storyboard.instantiateViewController(withIdentifier: "MoreTravelIdeasViewController") as! MoreTravelIdeasViewController
        moreTravelIdeaVC.agentId = (CurrentUser.sharedInstance.user?.agentInfo.agent_id)!
        moreTravelIdeaVC.categoryId = categoryId
        moreTravelIdeaVC.strTitle = title
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(moreTravelIdeaVC, animated: true)
    }
    
    func gotoPakcgesDetailsViewController(packges: PackagesModel)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let detailPackgesVC: DetailsPackagesViewController = storyboard.instantiateViewController(withIdentifier: "DetailsPackagesViewController") as! DetailsPackagesViewController
        detailPackgesVC.packgesDetails = packges
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(detailPackgesVC, animated: true)
    }
    
    func gotoTIDetailsViewController(travelIdeas: TravelIdeasModel)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let travelDetailsVC: TravelIdeasDetailsViewController = storyboard.instantiateViewController(withIdentifier: "TravelIdeasDetailsViewController") as! TravelIdeasDetailsViewController
        travelDetailsVC.travelItems = travelIdeas
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(travelDetailsVC, animated: true)
        
    }
    
    func gotoRequestToPlanViewController()  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let requestPlanVC: RequestPlanViewController = storyboard.instantiateViewController(withIdentifier: "RequestPlanViewController") as! RequestPlanViewController
        requestPlanVC.strImage = ""
        requestPlanVC.strSubject = "Enquiry"
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(requestPlanVC, animated: true)
        
    }
    
    func callingAgentNum()
    {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let agentDetailsVC = homeStoryboard.instantiateViewController(withIdentifier: "CallToAgentViewController") as! CallToAgentViewController
        self.present(agentDetailsVC, animated: false, completion: nil)
    }
    
    
}

extension LandingViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        dismiss(animated: true, completion: nil)
        self.gotoPackgesViewController(type: "0", search: place.name, title: place.name )
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

