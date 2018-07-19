//
//  User+Serializable.swift
//  Kollectin
//
//  Created by Pablo on 1/12/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum Keys: String {
    case id = "user_id"
    case email = "email"
    case name = "name"
    case phone = "phone"
    case image = "image"
    case agent_info = "agent_info"

}

extension User {
    
    static func deserialize(_ dictionary: [String: AnyObject]) -> User?
    {
        if let id = dictionary[Keys.id.rawValue] as? String
        {
            var agentInfo = [String: AnyObject]()
            let email = dictionary[Keys.email.rawValue] as? String ?? ""
            let userName = dictionary[Keys.name.rawValue] as? String ?? ""
            let phoneNum = dictionary[Keys.phone.rawValue] as? String ?? ""
            let imageUrl = dictionary[Keys.image.rawValue] as? String ?? ""
            let arrOfDict = dictionary[Keys.agent_info.rawValue]
            if ((arrOfDict?.count)! > 0) && (arrOfDict != nil)
            {
                agentInfo = (arrOfDict?.object(at: 0) as? [String: AnyObject])!
            }
            
            return User(id: id, email: email, name: userName, phone: phoneNum, image: imageUrl, agentInfo: agentInfo)
        }
        else
        {
            return nil
        }
    }
    
    
    func serialize() -> [String: AnyObject]
    {
        return [
            Keys.id.rawValue: self.id as AnyObject,
            Keys.email.rawValue: self.email as AnyObject,
            Keys.name.rawValue: self.name as AnyObject,
            Keys.phone.rawValue: self.phone as AnyObject,
            Keys.image.rawValue: self.image as AnyObject
        ]
    }
    
}
