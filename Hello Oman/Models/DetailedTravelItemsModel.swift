//
//  DetailedTravelItemsModel.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//


import Foundation
import SwiftyJSON

private enum DetailsKeys: String {
    case id = "id"
    case title = "title"
    case desc = "desc"
    case image = "image"
    case packages = "packages"
    
}

class DetailedTravelItemsModel {
    
    var id: String
    var title: String
    var desc: String
    var image: String
    var packagesModelList: [PackagesModel] = [PackagesModel]()
    
    // For customer of
    init(id: String, title: String, desc: String, image: String,packagesModelList : [PackagesModel]?) {
        
        self.id = id
        self.title = title
        self.desc = desc
        self.image = image
        if packagesModelList != nil {
            self.packagesModelList = packagesModelList!
        }
    }
}

extension DetailedTravelItemsModel {
    
    static func deserialize(_ dictionary: [String : AnyObject]) -> DetailedTravelItemsModel?
    {
        let id = dictionary[DetailsKeys.id.rawValue] as? String ?? ""
        let title = dictionary[DetailsKeys.title.rawValue] as? String ?? ""
        let desc = dictionary[DetailsKeys.desc.rawValue] as? String ?? ""
        let image = dictionary[DetailsKeys.image.rawValue] as? String ?? ""
        
        var packagesArray = [PackagesModel]()
        if let package = dictionary[DetailsKeys.packages.rawValue]
        {
            let json = JSON(package)
            let packageItems = json.arrayValue
            for item in packageItems {
                let Im = PackagesModel(json: item.object as AnyObject)
                packagesArray.append(Im)
            }
        }
        
        return DetailedTravelItemsModel(id : id, title: title, desc: desc,image: image, packagesModelList: packagesArray)
    }
    
}
