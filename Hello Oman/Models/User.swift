//
//  User.swift
//  Kollectin
//
//  Created by Pablo on 1/7/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation



class User: NSObject {
    
    var id: String = ""
    var email:String = ""
    var name: String = ""
    var phone: String = ""
    var image: String = ""
    var agentInfo = AgentInfo()
	
    
	// For customer of
    init(id: String, email: String, name: String, phone: String, image: String, agentInfo : [String: AnyObject]? ) {
        self.id = id
		self.email = email
		self.name = name
		self.phone = phone
        self.image = image
        if agentInfo != nil {
            self.agentInfo = AgentInfo(object: agentInfo as AnyObject)
        }
        
    }
	
}
