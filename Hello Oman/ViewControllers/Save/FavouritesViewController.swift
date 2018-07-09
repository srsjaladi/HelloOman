//
//  FavouritesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class FavouritesViewController: UIViewController,CAPSPageMenuDelegate,SavedPackagesVCDelegate,TravlIdeasVCDelegate {

    @IBOutlet weak var btnMainAndBack: UIBarButtonItem!

    var isfromMain: Bool = false
    var pageMenu: CAPSPageMenu?
    let pageMenuTag: Int = 500
    var selectedPageIndex: Int = 0
    var totalCount : Int = 0
    var positionPage : Int = 0
    var packgesDetails : PackagesModelList?
    var travelItems : [TravelIdeasModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
      
        if isfromMain {
            self.btnMainAndBack.image = UIImage(named: "menu")
        }
        else
        {
            self.btnMainAndBack.image = UIImage(named: "BackArrow")
        }
        
        self.getListFavouritePackages(userID: (CurrentUser.sharedInstance.user?.id)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshStores(_ position: Int, animated : Bool) {
        
        DispatchQueue.main.async {
             self.getListFavouritePackages(userID: (CurrentUser.sharedInstance.user?.id)!)
        }
        
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        if isfromMain {
            self.openLeft()
        }
        else
        {
             self.navigationController?.popViewController(animated:true)
        }
    }
    
    func getListFavouritePackages(userID : String)  {
        
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getAllFavouritePackages(userID, handler: { (response, error) in
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
                self.getListFavouriteTravelIdeas(userID: userID)
            }
        })
        
    }
    
    func getListFavouriteTravelIdeas(userID : String)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getFavouriteTravelPlansDetails(user_id: userID, handler: { (allTravelPlanDetails, error) in
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
                let travelPlansList = allTravelPlanDetails as [TravelIdeasModel]
                self.travelItems = travelPlansList
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
        
        let packgesVC: SavePackagesViewController = storyboard.instantiateViewController(withIdentifier: "SavePackagesViewController") as! SavePackagesViewController
        packgesVC.title = "PACKAGES"
        packgesVC.delegate = self
        packgesVC.FavouritesVC = self
        packgesVC.packgesDetails = self.packgesDetails
        controllerArray.append(packgesVC)
        itemCount += 1
        
        let TrvlIdeasVC: SavedTravelIdeasViewController = storyboard.instantiateViewController(withIdentifier: "SavedTravelIdeasViewController") as! SavedTravelIdeasViewController
        TrvlIdeasVC.title = "TRAVEL IDEAS"
        TrvlIdeasVC.delegate = self
        TrvlIdeasVC.FavouritesVC = self
        TrvlIdeasVC.travelItems = self.travelItems
        controllerArray.append(TrvlIdeasVC)
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
            .menuItemWidthBasedOnTitleTextWidth((itemCount) > 2),
            .enableHorizontalBounce(false)
        ]
        
        // Initialize page menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.view
            .frame.width, height: self.view.frame.height), pageMenuOptions: parameters, isFromBrand: false)
        pageMenu!.view.tag = pageMenuTag
        pageMenu?.delegate = self
        self.view.addSubview(pageMenu!.view)
        self.addPriorityToMenuGesuture(pageMenu!.controllerScrollView)
        self.pageMenu?.moveToPage(position, animated: animated)
        
    }
    
    fileprivate func getMenuItemWidth(_ items: Int) -> CGFloat{
        if (items <= 2) {
            return self.view.frame.width / CGFloat(items)
        }
        else {
            return (self.view.frame.width * 0.9) / 3
        }
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
        
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func gotoTIDetailsViewController(travelIdeas: TravelIdeasModel)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let travelDetailsVC: TravelIdeasDetailsViewController = storyboard.instantiateViewController(withIdentifier: "TravelIdeasDetailsViewController") as! TravelIdeasDetailsViewController
        travelDetailsVC.travelItems = travelIdeas
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(travelDetailsVC, animated: true)
        
    }
    
    func gotoPakcgesDetailsViewController(packges: PackagesModel)  {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let detailPackgesVC: DetailsPackagesViewController = storyboard.instantiateViewController(withIdentifier: "DetailsPackagesViewController") as! DetailsPackagesViewController
        detailPackgesVC.packgesDetails = packges
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(detailPackgesVC, animated: true)
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
    
}
