//
//  SavedTravelIdeasViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 03/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
private let kReuseCollectionCellID = "reuseCollectionCellID"


protocol TravlIdeasVCDelegate {
    func refreshStores(_ position: Int, animated : Bool)
}

class SavedTravelIdeasViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl?
    var delegate: TravlIdeasVCDelegate?
    var travelItems : [TravelIdeasModel]?
    var FavouritesVC: FavouritesViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRefreshControl()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (self.view.frame.width - 30)/2, height: 170.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "\(TravelIdeasCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCollectionCellID)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setRefreshControl() {
        //Set refreshController
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(SavedTravelIdeasViewController.startRefresh), for: UIControlEvents.valueChanged)
        self.collectionView.addSubview(refreshControl!)
        self.collectionView.alwaysBounceVertical = true
        refreshControl?.endRefreshing()
    }
    
    
    @objc func startRefresh() {
        
        if let delegate = delegate {
            delegate.refreshStores(1, animated: false)
        }
    }
    
    // MARK: - CollectionView Protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.travelItems?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCollectionCellID, for: indexPath) as! TravelIdeasCollectionViewCell
        
        let trvlIdeaObj =  self.travelItems?[indexPath.row]
        
        if let imageURL = URL(string: (trvlIdeaObj!.travelImageUrl))
        {
            cell.imgProfile.af_setImage(
                withURL: imageURL,
                placeholderImage: UIImage(named: "DefaultImage"),
                filter: nil,
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        cell.lblTitle.text = trvlIdeaObj?.travelTitle
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
         let trvlIdeaObj =  self.travelItems?[indexPath.row]
        self.FavouritesVC?.gotoTIDetailsViewController(travelIdeas: trvlIdeaObj!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.width - 30)/2 , height: 170.0)
        
    }
    


}
