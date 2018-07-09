//
//  IdeasModel.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

//
//  Product.swift
//  Kollectin
//
//  Created by Pablo on 1/13/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

class IdeasModel {
    
    var Ideas_id: String
    var Ideas_title: String
    var Ideas_desc : String
    var Ideas_fav: String
    var Ideas_image: String
    
    init(object: AnyObject) {
        let json = JSON(object)
        self.Ideas_id = json["id"].stringValue
        self.Ideas_title = json["title"].stringValue
        self.Ideas_desc = json["desc"].stringValue
        self.Ideas_fav = json["fav"].stringValue
        self.Ideas_image = json["image"].stringValue
    }
    
    init() {
        
        self.Ideas_id = ""
        self.Ideas_title  = ""
        self.Ideas_desc = ""
        self.Ideas_fav  = ""
        self.Ideas_image = ""
    }
}

func ==(lhs: IdeasModel, rhs: IdeasModel) -> Bool {
    return
        lhs.Ideas_id == rhs.Ideas_id
}

func !=(lhs: IdeasModel, rhs: IdeasModel) -> Bool {
    return
        lhs.Ideas_id != rhs.Ideas_id
}
