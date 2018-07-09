//
//  ImageModel.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 06/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum ImageModelKeys: String {
    case image_id = "image_id"
    case image_URL = "package_image"
    
}

class ImageModel {
    
    var image_id: String
    var image_URL: String
  
    
    init(object: AnyObject) {
        let json = JSON(object)
        self.image_id = json["image_id"].stringValue
        self.image_URL = json["package_image"].stringValue
      
    }
    
    init() {
        
        self.image_id = ""
        self.image_URL  = ""
      
    }
    
    
}

func ==(lhs: ImageModel, rhs: ImageModel) -> Bool {
    return
        lhs.image_id == rhs.image_id
}

func !=(lhs: ImageModel, rhs: ImageModel) -> Bool {
    return
        lhs.image_id != rhs.image_id
}
