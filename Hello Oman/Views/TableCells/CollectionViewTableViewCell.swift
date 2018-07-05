//
//  CollectionViewTableViewCell.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 02/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
private let kReuseCollectionCellID = "reuseCollectionCellID"
private let kReuseSmallCollectionCellID = "reuseSmallCollectionCellID"

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 150.0, height: 100.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "\(BigCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCollectionCellID)
        
         collectionView.register(UINib(nibName: "\(SmallCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseSmallCollectionCellID)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CollectionViewTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:true) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}


