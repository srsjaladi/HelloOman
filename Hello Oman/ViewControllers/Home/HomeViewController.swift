//
//  HomeViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
private let kReuseTableCellID = "reuseTableCellID"
private let kReuseDetailTableCellID = "reuseDetailTableCellID"
private let kReuseCollectionCellID = "reuseCollectionCellID"
private let kReuseSmallCollectionCellID = "reuseSmallCollectionCellID"
private let kReuseCitySmallCollectionCellID = "reuseCitySmallCollectionCellID"
private let kBtnMoreTag = 1200
private let kTravelIdeasCollectionViewTag = 200
private let kCountriesCollectionViewTag = 100
private let kCitiesCollectionViewTag = 10

protocol HomeVCDelegate {
    func refreshStores(_ position: Int, animated : Bool)
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl?
    var delegate: HomeVCDelegate?
    var homeDetails : HomeModel?
    var containerLandingVC: LandingViewController?
    var rect = CGRect()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "HomeSectionHeaderCReusableView", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "HomeSectionHeaderCReusableView")
        self.setRefreshControl()
        
        self.tblView.register(UINib(nibName: "\(CollectionViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
         self.tblView.register(UINib(nibName: "\(DetaildTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseDetailTableCellID)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRefreshControl() {
        //Set refreshController
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeViewController.startRefresh), for: UIControlEvents.valueChanged)
        self.tblView.addSubview(refreshControl!)
        self.tblView.alwaysBounceVertical = true
        refreshControl?.endRefreshing()
    }
    
    
    @objc func startRefresh() {
        
        if let delegate = delegate {
            delegate.refreshStores(0, animated: false)
        }
    }
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section ==  3)
        {
            return 100.0
        }
        else
        {
            return 170.0
        }
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4 {
            return 0
        }
        else
        {
            return 1
        }
        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 4
        {
            return 60.0
        }
        else
        {
            return 30.0
        }
        
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCReusableView" ) as! HomeSectionHeaderCReusableView
        if section == 0
        {
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = "Travel Plans"
            headerView.btnForPlan.isHidden = true
            headerView.btnMore.isHidden = false
            headerView.btnMore.tag = section + kBtnMoreTag
            headerView.btnMore.addTarget(self, action: #selector(HomeViewController.btnMoreClicked(sender:)), for: .touchUpInside)
            return headerView
        }
        else if section == 1
        {
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = "Inbound Holidays"
            headerView.btnForPlan.isHidden = true
            headerView.btnMore.isHidden = false
            headerView.btnMore.tag = section + kBtnMoreTag
            headerView.btnMore.addTarget(self, action: #selector(HomeViewController.btnMoreClicked(sender:)), for: .touchUpInside)
            return headerView
        }
        else if section == 2
        {
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = "Outbond Holidays"
            headerView.btnForPlan.isHidden = true
            headerView.btnMore.isHidden = false
            headerView.btnMore.tag = section + kBtnMoreTag
            headerView.btnMore.addTarget(self, action: #selector(HomeViewController.btnMoreClicked(sender:)), for: .touchUpInside)
            return headerView
        }
        else if section == 3
        {
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = "Looking for a customised tour package ?"
            headerView.btnMore.isHidden = true
            headerView.btnForPlan.isHidden = true
            return headerView
        }
        else
        {
            headerView.tailingConstraint.constant = 30.0
            headerView.leadingConstraint.constant = 30.0
            headerView.lblDynamic.text = "PLAN YOUR TRIP"
            headerView.viewForContent.layer.cornerRadius = 5.0
            headerView.viewForContent.clipsToBounds = true
            headerView.btnMore.isHidden = true
            headerView.btnForPlan.isHidden = false
            headerView.btnForPlan.addTarget(self, action: #selector(HomeViewController.btnForPlanClicked(sender:)), for: .touchUpInside)
            return headerView
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: kReuseDetailTableCellID, for: indexPath) as! DetaildTableViewCell
            
            cell.lblText.attributedText =  getAttributedStringWithLineSpacing("Provide your details \n We will send it to travel agents \n They will call you &customize it", lineSpacing: 15.0)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! CollectionViewTableViewCell
            
            if indexPath.section == 0
            {
                cell.setCollectionViewDataSourceDelegate(self, forRow: kTravelIdeasCollectionViewTag)
                cell.collectionViewOffset = 0
                
                return cell
            }
            else if indexPath.section == 1
            {
                cell.setCollectionViewDataSourceDelegate(self, forRow: kCitiesCollectionViewTag)
                cell.collectionViewOffset = 0
                
                return cell
            }
            else
            {
                cell.setCollectionViewDataSourceDelegate(self, forRow: kCountriesCollectionViewTag)
                cell.collectionViewOffset = 0
                
                return cell
            }
           
        }
       
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
     @objc func btnMoreClicked(sender: AnyObject) {
        
        switch (sender.tag - kBtnMoreTag) {
        case 0:
            self.containerLandingVC?.gotoTravelIdeasViewController(categoryId: "0", title: "Travel Ideas")
            break
        case 1:
            self.containerLandingVC?.gotoPackgesViewController(type: "1", search:"", title:"Inbound Holidays" )
            break
        case 2:
             self.containerLandingVC?.gotoPackgesViewController(type: "2", search:"", title:"Outbond Holidays" )
            break
        default:
            break
        }
    }
    
    @objc func btnForPlanClicked(sender: AnyObject) {
        //RequestPlanViewController
        self.containerLandingVC?.gotoPlanRequestPage(subject: "Enquiry", image: "")
    }
    
    fileprivate func getAttributedStringWithLineSpacing(_ string: String, lineSpacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    // MARK: - CollectionView Protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView.tag ==  kTravelIdeasCollectionViewTag)
        {
            return (self.homeDetails?.travelIdeas.count)!
        }
        else if (collectionView.tag ==  kCountriesCollectionViewTag)
        {
            return (self.homeDetails?.countries.count)!
        }
        else
        {
            return (self.homeDetails?.cities.count)!
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if (collectionView.tag ==  kTravelIdeasCollectionViewTag) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCollectionCellID, for: indexPath) as! BigCollectionViewCell
            
             let trvlIdeaObj =  self.homeDetails?.travelIdeas[indexPath.row]
            
            if let imageURL = URL(string: (trvlIdeaObj!.travelImageUrl))
            {
                cell.imageTitle.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
            
            cell.lblTitle.text = trvlIdeaObj?.travelTitle
            
            let attributeString = NSAttributedString(string: (trvlIdeaObj?.travelTitle)!, attributes: [ NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 12.0)! ])
            
            rect = attributeString.boundingRect(with: CGSize(width:  (cell.lblTitle.frame.width - 10), height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            cell.lblTitleConstraint.constant = rect.size.height + 10.0
            return cell
        }
        else if (collectionView.tag ==  kCountriesCollectionViewTag)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseSmallCollectionCellID, for: indexPath) as! SmallCollectionViewCell
            
            let countriesObj =  self.homeDetails?.countries[indexPath.row]
            
            if let imageURL = URL(string: (countriesObj!.countryImageUrl))
            {
                cell.imageTitle.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
            
            cell.lblTitle.text = countriesObj?.countryName
             return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCitySmallCollectionCellID, for: indexPath) as! SmallCollectionViewCell
            
            let citiesObj =  self.homeDetails?.cities[indexPath.row]
            
            if let imageURL = URL(string: (citiesObj!.cityImageUrl))
            {
                cell.imageTitle.af_setImage(
                    withURL: imageURL,
                    placeholderImage: UIImage(named: "DefaultImage"),
                    filter: nil,
                    imageTransition: .crossDissolve(0.3)
                )
            }
            
            cell.lblTitle.text = citiesObj?.cityName
            
            return cell
        }
        

        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (collectionView.tag ==  kTravelIdeasCollectionViewTag) {
             let trvlIdeaObj =  self.homeDetails?.travelIdeas[indexPath.row]
            self.containerLandingVC?.gotoTIDetailsViewController(travelIdeas: trvlIdeaObj!)
        }
        else
        {
            var countriesObj = CountriesModel()
            var citiessObj = CitiesModel()
            if (collectionView.tag ==  kCountriesCollectionViewTag)
            {
                 countriesObj =  (self.homeDetails?.countries[indexPath.row])!
            }
            else
            {
                citiessObj =  (self.homeDetails?.cities[indexPath.row])!
            }
            self.containerLandingVC?.gotoPackgesViewController(type: "0", search: (collectionView.tag ==  kCountriesCollectionViewTag) ? (countriesObj.countryName):(citiessObj.cityName), title: (collectionView.tag ==  kCountriesCollectionViewTag) ? (countriesObj.countryName):(citiessObj.cityName))
           
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 230.0 , height: 150.0)
        
    }
    
}
