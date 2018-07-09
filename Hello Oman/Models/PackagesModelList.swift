//
//  PhotoArchiveStore.swift
//  Kollectin
//
//  Created by Sivaramsingh on 02/05/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum PackagesModelKeys: String {
    case users = "Packages"
    
}

class PackagesModelList {
    
    var packagesModelList: [PackagesModel] = [PackagesModel]()
   
    // For customer of
    init(packagesModelList : [PackagesModel]?) {
        
        if packagesModelList != nil {
            self.packagesModelList = packagesModelList!
        }
        
    }
}

extension PackagesModelList {
    
    static func deserialize(_ dictionary: [String : AnyObject]) -> PackagesModelList?
    {
        
        
        var packagesArray = [PackagesModel]()
        if let package = dictionary[PackagesModelKeys.users.rawValue]
        {
            let json = JSON(package)
            let packageItems = json.arrayValue
            for item in packageItems {
                let Im = PackagesModel(json: item.object as AnyObject)
                packagesArray.append(Im)
            }
        }
        
        return PackagesModelList(packagesModelList: packagesArray)
    }
    
}

