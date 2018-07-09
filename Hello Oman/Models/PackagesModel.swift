//
//  PackagesModel.swift
//  Travelpackages
//
//  Created by Ajay Shinu on 15/02/18.
//  Copyright © 2018 AkInfoPark. All rights reserved.
//

import Foundation
import SwiftyJSON
struct PackagesModel
{
    var packageId = ""
    var packageTitle = ""
    var packageDuration = ""
    var packagePrice = ""
    var packageBudget = ""
    var packageTheme = ""
    var packagePlaces = ""
    var packageCountries = ""
    var packageInclusions = ""
    var arrPackageImages = [ImageModel]()
    var packageFav = ""
    var packageType = ""
    
    init() {
        
    }
    
    init(json:AnyObject?) {
        
        let data = JSON(json!)
        packageId = data["id"].stringValue
        packageTitle = data["title"].stringValue
        packageDuration = data["duration"].stringValue
        packagePrice = data["price"].stringValue
        packageBudget = data["budget"].stringValue
        packageTheme = data["theme"].stringValue
        packagePlaces = data["places"].stringValue
        packageCountries = data["countries"].stringValue
        packageInclusions = data["inclusions"].stringValue
        
        let imageDictArray = data["image"].arrayValue
        for item in imageDictArray {
            let image = ImageModel(object: item.object as AnyObject)
            self.arrPackageImages.append(image)
        }
        
        packageFav = data["fav"].stringValue
        packageType = data["type"].stringValue
        
    }
}


