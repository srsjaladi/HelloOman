//
//  UpdatedAgentInfo.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 10/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum UpdatedAgentInfoKeys: String {
    case agent_id = "id"
    case agent_name = "name"
    case agent_email = "email"
    case agent_phone = "phone"
    case agent_unique_id = "unique_id"
    case agent_image = "image"
    
}

class UpdatedAgentInfo {
    
    var agent_id: String
    var agent_name: String
    var agent_email : String
    var agent_phone: String
    var agent_unique_id: String
    var agent_image : String
    
    init(object: AnyObject) {
        let json = JSON(object)
        self.agent_id = json["id"].stringValue
        self.agent_name = json["name"].stringValue
        self.agent_email = json["email"].stringValue
        self.agent_phone = json["phone"].stringValue
        self.agent_unique_id = json["unique_id"].stringValue
        self.agent_image = json["image"].stringValue
    }
    
    init() {
        
        self.agent_id = ""
        self.agent_name  = ""
        self.agent_email = ""
        self.agent_phone  = ""
        self.agent_unique_id = ""
        self.agent_image  = ""
    }
    
}



