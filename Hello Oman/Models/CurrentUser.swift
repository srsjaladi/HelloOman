//
//  CurrentUser.swift
//  Kollectin
//
//  Created by Pablo on 1/6/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import UIKit

private enum Keys: String {
    case Token = "token"
    case User = "UserInfo"
    case Agent = "AgentInfo"
}

class CurrentUser {
    
    static let sharedInstance = CurrentUser()
    
    fileprivate var defaults: UserDefaults = UserDefaults.standard
    var user: User?
    
    
 
    func deserialize(_ data: [String: AnyObject]) {
        
        guard let uUser = data[Keys.User.rawValue] as? [String: AnyObject] else {
            return
        }
        self.user = User.deserialize(uUser)
       
    }
    
    func agentDeserialize(_ data: [String: AnyObject]) {
        
        guard let agent = data[Keys.Agent.rawValue] as? [String: AnyObject] else {
            return
        }
        self.user?.agentInfo = AgentInfo(object: agent as AnyObject)
        
    }
    
    func save() {
        
        defaults.set(user?.serialize(), forKey: Keys.User.rawValue)
        defaults.set(user?.agentInfo.serialize(), forKey: Keys.Agent.rawValue)
        defaults.synchronize()
    }
    
    func load() {
        if let dictionary = defaults.object(forKey: Keys.User.rawValue) as? [String: AnyObject] {
            
            if let dictionaryAgent = defaults.object(forKey: Keys.Agent.rawValue) as? [String: AnyObject] {
                let agentDict = AgentInfo(object: dictionaryAgent as AnyObject)
                self.user = (User.deserialize(dictionary)! as User)
                self.user?.agentInfo = agentDict
            }
            
            
            
        }
       
    }
    
    fileprivate func wipe() {
        
        self.user = nil
        defaults.removeObject(forKey: Keys.User.rawValue)
        defaults.synchronize()
    }
    
    func logOut() {
        wipe()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.goToLogin(true)
    }
    
}

