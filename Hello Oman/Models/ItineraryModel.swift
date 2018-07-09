//
//  ItineraryModel.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 08/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItineraryModel {
    
    var Itinerary_id: String
    var Itinerary_title: String
    var Itinerary_desc : String
    
    init(object: AnyObject) {
        let json = JSON(object)
        self.Itinerary_id = json["id"].stringValue
        self.Itinerary_title = json["title"].stringValue
        self.Itinerary_desc = json["desc"].stringValue
    }
    
    init() {
        
        self.Itinerary_id = ""
        self.Itinerary_title  = ""
        self.Itinerary_desc = ""
    }
}
