//
//  Product.swift
//  Kollectin
//
//  Created by Pablo on 1/13/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum AgentKeys: String {
    case agent_id = "agent_id"
    case agent_name = "agent_name"
    case agent_email = "agent_email"
    case agent_phone = "agent_phone"
    case agent_unique_id = "agent_unique_id"
    case agent_image = "agent_image"
    
}

class AgentInfo {

    var agent_id: String
    var agent_name: String
    var agent_email : String
    var agent_phone: String
    var agent_unique_id: String
    var agent_image : String
   
    init(object: AnyObject) {
        let json = JSON(object)
        self.agent_id = json["agent_id"].stringValue
        self.agent_name = json["agent_name"].stringValue
        self.agent_email = json["agent_email"].stringValue
        self.agent_phone = json["agent_phone"].stringValue
        self.agent_unique_id = json["agent_unique_id"].stringValue
        self.agent_image = json["agent_image"].stringValue
    }
    
    init() {
        
        self.agent_id = ""
        self.agent_name  = ""
        self.agent_email = ""
        self.agent_phone  = ""
        self.agent_unique_id = ""
        self.agent_image  = ""
    }
    
    func serialize() -> [String: AnyObject]
    {
        return [
            AgentKeys.agent_id.rawValue: self.agent_id as AnyObject,
            AgentKeys.agent_name.rawValue: self.agent_name as AnyObject,
            AgentKeys.agent_email.rawValue: self.agent_email as AnyObject,
            AgentKeys.agent_phone.rawValue: self.agent_phone as AnyObject,
            AgentKeys.agent_unique_id.rawValue: self.agent_unique_id as AnyObject,
            AgentKeys.agent_image.rawValue: self.agent_image as AnyObject
        ]
    }
}

func ==(lhs: AgentInfo, rhs: AgentInfo) -> Bool {
    return
        lhs.agent_id == rhs.agent_id
}

func !=(lhs: AgentInfo, rhs: AgentInfo) -> Bool {
    return
        lhs.agent_id != rhs.agent_id
}
