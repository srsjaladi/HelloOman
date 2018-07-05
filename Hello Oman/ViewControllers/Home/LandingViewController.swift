//
//  LandingViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit



class LandingViewController: UIViewController,CAPSPageMenuDelegate,HomeVCDelegate,PackagesVCDelegate,TravelPlansVCDelegate {

    
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    var pageMenu: CAPSPageMenu?
    let pageMenuTag: Int = 100
    var selectedPageIndex: Int = 0
    var totalCount : Int = 0
    var positionPage : Int = 0
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var btnContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        let img = UIImage(named: "TabBarImg")
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.buildPageMenu(positionPage, animated: true)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.3)) {
            // your function here
            self.buildPageMenu(position, animated: animated)
        }
        
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
        controllerArray.append(homeVC)
        itemCount += 1
        
        let packagesVC: PackagesViewController = storyboard.instantiateViewController(withIdentifier: "PackagesViewController") as! PackagesViewController
        packagesVC.title = "PACKAGES"
        packagesVC.delegate = self
        controllerArray.append(packagesVC)
        itemCount += 1
        
        let trvlPlansVC: TravelPlansViewController = storyboard.instantiateViewController(withIdentifier: "TravelPlansViewController") as! TravelPlansViewController
        trvlPlansVC.title = "TRAVEL PLANS"
        trvlPlansVC.delegate = self
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
    }
}

