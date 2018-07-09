//
//  SavePackagesViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
private let kReuseTableCellID = "reuseTableCellID"
private let kBtnMoreTag = 1400

protocol SavedPackagesVCDelegate {
    func refreshStores(_ position: Int, animated : Bool)
}

class SavePackagesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tblView: UITableView!
    var refreshControl: UIRefreshControl?
    var delegate: SavedPackagesVCDelegate?
     var packgesDetails : PackagesModelList?
    var FavouritesVC: FavouritesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRefreshControl()
        
        self.tblView.register(UINib(nibName: "\(ListViewTableViewCell.self)", bundle: nil), forCellReuseIdentifier: kReuseTableCellID)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRefreshControl() {
        //Set refreshController
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(SavePackagesViewController.startRefresh), for: UIControlEvents.valueChanged)
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
        
        return 100.0
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
        
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelObj = self.packgesDetails?.packagesModelList[indexPath.row]
        self.FavouritesVC?.gotoPakcgesDetailsViewController(packges: modelObj!)
        
    }
    
}
