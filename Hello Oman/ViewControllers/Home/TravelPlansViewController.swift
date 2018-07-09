//
//  TravelPlansViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 24/06/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
private let kReuseTableCellID = "reuseTableCellID"
private let kReuseDetailTableCellID = "reuseDetailTableCellID"
private let kReuseCollectionCellID = "reuseCollectionCellID"
private let kBtnMoreTag = 1400

protocol TravelPlansVCDelegate {
    func refreshStores(_ position: Int, animated : Bool)
}

class TravelPlansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl?
    var delegate: TravelPlansVCDelegate?
    var travelPlansList = [CategoryModel]()
    var containerLandingVC: LandingViewController?
    var numOfSections : Int = 0
    var rect = CGRect()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "HomeSectionHeaderCReusableView", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "HomeSectionHeaderCReusableView")
         self.setRefreshControl()
        
        self.tblView.register(UINib(nibName: "\(CollectionViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        
        self.tblView.register(UINib(nibName: "\(DetaildTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseDetailTableCellID)
        
        numOfSections = (self.travelPlansList.count + 1)
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
        refreshControl?.addTarget(self, action: #selector(TravelPlansViewController.startRefresh), for: UIControlEvents.valueChanged)
        self.tblView.addSubview(refreshControl!)
        self.tblView.alwaysBounceVertical = true
        refreshControl?.endRefreshing()
    }
    
    
    @objc func startRefresh() {
        
        if let delegate = delegate {
            delegate.refreshStores(2, animated: false)
        }
    }
    
    
    // MARK: - TableView Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == (numOfSections - 1) {
            return 0
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == (numOfSections - 1)
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
        if section == (numOfSections - 1)
        {
            headerView.tailingConstraint.constant = 30.0
            headerView.leadingConstraint.constant = 30.0
            headerView.lblDynamic.text = "SEE ALL"
            headerView.viewForContent.layer.cornerRadius = 5.0
            headerView.viewForContent.clipsToBounds = true
            headerView.btnMore.isHidden = true
            headerView.btnForPlan.isHidden = false
            headerView.btnForPlan.addTarget(self, action: #selector(TravelPlansViewController.btnSeeAllClicked(sender:)), for: .touchUpInside)
            return headerView
        }
        else
        {
            let ObjCurrent = self.travelPlansList[section]
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = ObjCurrent.category
            headerView.btnForPlan.isHidden = true
            headerView.btnMore.isHidden = false
            headerView.btnMore.tag = section + kBtnMoreTag
            headerView.btnMore.addTarget(self, action: #selector(TravelPlansViewController.btnMoreClicked(sender:)), for: .touchUpInside)
            return headerView
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! CollectionViewTableViewCell
        
         let ObjCurrent = self.travelPlansList[indexPath.section]
        cell.CategoryItem = ObjCurrent
        cell.setCollectionViewDataSourceDelegate(self, forRow:Int(ObjCurrent.id)!)
        cell.collectionViewOffset = 0
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    @objc func btnMoreClicked(sender: AnyObject) {
        let ObjCurrent = self.travelPlansList[(sender.tag - kBtnMoreTag)]
        self.containerLandingVC?.gotoTravelIdeasViewController(categoryId: ObjCurrent.id, title: ObjCurrent.category)
        
    }
    
    @objc func btnSeeAllClicked(sender: AnyObject) {
        self.containerLandingVC?.gotoTravelIdeasViewController(categoryId: "0", title: "Travel Ideas")
    }
    
    fileprivate func getAttributedStringWithLineSpacing(_ string: String, lineSpacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
   
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.openLeft()
    }
    
}

extension TravelPlansViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    // MARK: - CollectionView Protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var numForCurrentModel : Int = 0
        
        for i in 0 ... (self.travelPlansList.count - 1)
        {
            let ObjCurrent = self.travelPlansList[i]
            if collectionView.tag == Int(ObjCurrent.id)
            {
                numForCurrentModel = i
            }
        }
        
        let ObjCurrent = self.travelPlansList[numForCurrentModel]
        return ObjCurrent.ideas.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCollectionCellID, for: indexPath) as! BigCollectionViewCell
        
        var numForCurrentObject : Int = 0
        
        for i in 0 ... (self.travelPlansList.count - 1)
        {
            let ObjCurrent = self.travelPlansList[i]
            if collectionView.tag == Int(ObjCurrent.id)
            {
                numForCurrentObject = i
            }
        }
        
        let ObjCurrent = self.travelPlansList[numForCurrentObject]
        let IdeasObj = ObjCurrent.ideas[indexPath.row]
        
        if let imageURL = URL(string: (IdeasObj.Ideas_image))
        {
            cell.imageTitle.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        cell.lblLatest.text = ObjCurrent.category
        cell.lblTitle.text = IdeasObj.Ideas_title
        let attributeString = NSAttributedString(string: (IdeasObj.Ideas_title), attributes: [ NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 12.0)! ])
        
        rect = attributeString.boundingRect(with: CGSize(width:  (cell.lblTitle.frame.width - 10), height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        cell.lblTitleConstraint.constant = rect.size.height + 10.0
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        var numForCurrentObject : Int = 0
        for i in 0 ... (self.travelPlansList.count - 1)
        {
            let ObjCurrent = self.travelPlansList[i]
            if collectionView.tag == Int(ObjCurrent.id)
            {
                numForCurrentObject = i
            }
        }
        
        let ObjCurrent = self.travelPlansList[numForCurrentObject]
        let IdeasObj = ObjCurrent.ideas[indexPath.row]
        
        var objtravel = TravelIdeasModel()
        objtravel.travelTitle = IdeasObj.Ideas_title
        objtravel.travelId = IdeasObj.Ideas_id
        objtravel.travelIsFavourite = IdeasObj.Ideas_fav
        objtravel.travelDesc = IdeasObj.Ideas_desc
        objtravel.travelImageUrl = IdeasObj.Ideas_image
    
        self.containerLandingVC?.gotoTIDetailsViewController(travelIdeas: objtravel)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 230.0 , height: 150.0)
        
    }
    
}
