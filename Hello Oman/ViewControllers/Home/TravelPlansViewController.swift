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
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            return 0
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tblView.dequeueReusableHeaderFooterView(withIdentifier: "HomeSectionHeaderCReusableView" ) as! HomeSectionHeaderCReusableView
        if section == 0
        {
            headerView.tailingConstraint.constant = 0.0
            headerView.leadingConstraint.constant = 0.0
            headerView.lblDynamic.text = "Weekend Getaways"
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
            headerView.lblDynamic.text = "Honeymoon"
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
            headerView.lblDynamic.text = "Cool"
            headerView.btnForPlan.isHidden = true
            headerView.btnMore.isHidden = false
            headerView.btnMore.tag = section + kBtnMoreTag
            headerView.btnMore.addTarget(self, action: #selector(TravelPlansViewController.btnMoreClicked(sender:)), for: .touchUpInside)
            return headerView
        }
        else
        {
            headerView.tailingConstraint.constant = 30.0
            headerView.leadingConstraint.constant = 30.0
            headerView.lblDynamic.text = "SEE ALL"
            headerView.btnMore.isHidden = true
            headerView.btnForPlan.isHidden = false
            headerView.btnForPlan.addTarget(self, action: #selector(TravelPlansViewController.btnSeeAllClicked(sender:)), for: .touchUpInside)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseTableCellID, for: indexPath) as! CollectionViewTableViewCell
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = 0
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func btnMoreClicked(sender: AnyObject) {
        print("Clicked")
    }
    
    @objc func btnSeeAllClicked(sender: AnyObject) {
        print("Plan Clicked")
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
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCollectionCellID, for: indexPath) as! BigCollectionViewCell
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150.0 , height: 100.0)
        
    }
    
}
