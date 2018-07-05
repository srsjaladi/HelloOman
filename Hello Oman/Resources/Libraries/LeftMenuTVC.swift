//
//  LeftMenuTVC.swift
//  Kollectin
//
//  Created by Pablo on 1/11/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import UIKit
import AlamofireImage

private enum MenuOption: String {
    case Home = "Home"
    case TourPackages = "Tour Packages"
    case TravelIdeas = "Travel Ideas"
    case SavedItems = "Saved Items"
    case ShareThisApp = "Share this app"
    case RateUS = "Rate us"
    case ContactUs = "Contact us"
    case ChangePw = "Change Password"
    case Logout = "Logout"
    case Account = "Account"
}

class LeftMenuTVC: UITableViewController {
	
	fileprivate var rowsList = [[MenuOption]]()
    
    var containerHomeVC: LandingViewController!
    var savedVC: FavouritesViewController!
    var changeVC: ChangePwViewController!
    var accountVC: MyAccountViewController!
   

    fileprivate var selectedMenu: MenuOption = .Home
    fileprivate var actualAvailableMenuItems: [MenuOption]?
    
    @IBOutlet weak var btnForTop: UIButton!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var brandLogoImg: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var tblView: UITableView!
    
    var refreshHomeContainer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.borderColor = UIColor.warmGrey().cgColor
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.size.width/2
        
        self.tableView.tableHeaderView = self.headerView
		self.customizeSlideMenu()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        rowsList = self.availableMenu()
        if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.image)!)
        {
            self.imgProfile.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        self.lblUserName.text = CurrentUser.sharedInstance.user?.name ?? ""
        self.lblUserEmail.text = CurrentUser.sharedInstance.user?.email ?? ""
        if let imageURL = URL(string: (CurrentUser.sharedInstance.user?.agentInfo.agent_image)!)
        {
            self.brandLogoImg.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "brandLogo"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        self.tableView.reloadData()
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        self.closeLeft()
    }
	
	fileprivate func customizeSlideMenu() {
		self.slideMenuController()?.changeLeftViewWidth(280)
	}
	
    fileprivate func availableMenu() -> [[MenuOption]] {
        
        var menuItems: [[MenuOption]] = []
        
        var list = [MenuOption]()
        list.append(.Home)
        list.append(.TourPackages)
        list.append(.TravelIdeas)
        list.append(.SavedItems)
        menuItems.append(list)
        
        list = [MenuOption]()
        list.append(.ShareThisApp)
        list.append(.RateUS)
		list.append(.ContactUs)
        list.append(.ChangePw)
        list.append(.Logout)
        menuItems.append(list)
        
		return menuItems
	}
    
    fileprivate func changeViewController(_ menu: MenuOption) {
        switch menu {
        case .Home:
            self.closeLeft()
        
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            self.containerHomeVC = homeStoryboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
            self.containerHomeVC.positionPage = 0
            let navigationController = UINavigationController(rootViewController: self.containerHomeVC)
            self.slideMenuController()?.changeMainViewController(navigationController, close: true)
            break
        case .TourPackages :
                self.closeLeft()
                
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                self.containerHomeVC = homeStoryboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
                self.containerHomeVC.positionPage = 1
                let navigationController = UINavigationController(rootViewController: self.containerHomeVC)
                self.slideMenuController()?.changeMainViewController(navigationController, close: true)
            break
        case .TravelIdeas:
            self.closeLeft()
            
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            self.containerHomeVC = homeStoryboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
            self.containerHomeVC.positionPage = 2
            let navigationController = UINavigationController(rootViewController: self.containerHomeVC)
            self.slideMenuController()?.changeMainViewController(navigationController, close: true)
            break
        case .SavedItems:
            self.closeLeft()
            
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            self.savedVC = homeStoryboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            self.savedVC.positionPage = 0
            self.savedVC.isfromMain = true
            self.savedVC.pageMenu?.moveToPage(0, animated: true)
            let navigationController = UINavigationController(rootViewController: self.savedVC)
            self.slideMenuController()?.changeMainViewController(navigationController, close: true)
            break
        case .ChangePw:
            self.closeLeft()
            
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            self.changeVC = homeStoryboard.instantiateViewController(withIdentifier: "ChangePwViewController") as! ChangePwViewController
            let navigationController = UINavigationController(rootViewController: self.changeVC)
            self.slideMenuController()?.changeMainViewController(navigationController, close: true)
            break
        case .Logout:
            CurrentUser.sharedInstance.logOut()
            break
        default:
            break
        }
    }
	
 	
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return rowsList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 42.0
    }
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowsList[section].count
	}
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 0
        {
            return 0.0
        }
        else
        {
            return 40.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let lineView = UIView(frame: CGRect(x: 0, y: 1, width: UIScreen.main.bounds.width, height: 1.0))
        lineView.backgroundColor = UIColor.lightGray
        
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 25, y: 7, width: 150, height: 28))
        labelView.text = "Spread the Word"
        labelView.textColor = UIColor.warmGrey()
        labelView.font = UIFont.dinProRegular(14.0)
        
        headerView.addSubview(lineView)
        headerView.addSubview(labelView)
        return headerView
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTVCell", for: indexPath) as! LeftMenuTVCell
		
        let rows = rowsList[indexPath.section]
        if let menu:MenuOption = rows[indexPath.row] {
			
			cell.titlemenu.text = menu.rawValue
            cell.picker.image = UIImage(named: "\(menu.rawValue).png")
            
			//Selected
			if(menu == selectedMenu) {
                cell.titlemenu.textColor = UIColor.sandyBrownColor()
                cell.picker.image = UIImage(named: "\(menu.rawValue)Selected.png")
			}
			else {
                cell.titlemenu.textColor = UIColor.warmGrey()
                cell.picker.image = UIImage(named: "\(menu.rawValue).png")
			}
		}
		
		return cell
		
	}
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let menu:MenuOption = rowsList[indexPath.section][indexPath.row]
        {
            if selectedMenu == menu
            {
                closeLeft()
            }
            else
            {
                selectedMenu = menu
                changeViewController(menu)
                tableView.reloadData()
            }
           
        }
    }
    
    @IBAction func btnTopClicked(_ sender: Any) {
        self.closeLeft()
        selectedMenu = MenuOption(rawValue: "Account")!
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        self.accountVC = homeStoryboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        let navigationController = UINavigationController(rootViewController: self.accountVC)
        self.slideMenuController()?.changeMainViewController(navigationController, close: true)
    }
    
    
}
