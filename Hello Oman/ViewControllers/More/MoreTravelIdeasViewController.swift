//
//  MoreTravelIdeasViewController.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD
private let kReuseCollectionCellID = "reuseCollectionCellID"

class MoreTravelIdeasViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var travelItems : [TravelIdeasModel]?
    var agentId : String = ""
    var strTitle : String = ""
    var categoryId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (self.view.frame.width - 30)/2, height: 170.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "\(TravelIdeasCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCollectionCellID)
        
        self.title = strTitle
        self.getListMoreTravelIdeas(userID: agentId, categoryId: categoryId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }

    // MARK: - CollectionView Protocol
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.travelItems != nil {
            if (self.travelItems?.count)! > 0 {
                return (self.travelItems?.count)!
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
        
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let travelDetailsVC: TravelIdeasDetailsViewController = storyboard.instantiateViewController(withIdentifier: "TravelIdeasDetailsViewController") as! TravelIdeasDetailsViewController
        travelDetailsVC.travelItems = trvlIdeaObj
        self.navigationController?.navigationBar.barTintColor  = UIColor.oldPinkColor()
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.pushViewController(travelDetailsVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.width - 30)/2 , height: 170.0)
        
    }
    
    func getListMoreTravelIdeas(userID : String, categoryId : String)  {
        MBProgressHUD.showHUDAddedGlobal()
        HelloOmanAPI.sharedInstance.getMoreTravelPlansDetails(user_id: userID,categoryid:categoryId, handler: { (allTravelPlanDetails, error) in
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
                self.collectionView.reloadData()
            }
        })
    }
    

}
