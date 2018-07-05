//
//  KollectinAPI.swift
//  Kollectin
//
//  Created by Pablo on 1/4/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private struct Strings{
    static let TOKEN_HEADER_KEY = "x-access-token"
    static let CONTENT_TYPE = "Content-Type"
    
}

private struct ContentTypes {

    static let applicationJSON = "application/json"
}

class HelloOmanAPI {

    static let sharedInstance = HelloOmanAPI()
    fileprivate let alamoFireManager : Alamofire.SessionManager!
    
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // seconds
        configuration.timeoutIntervalForResource = 20
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    fileprivate func getStatusCodeFrom(_ response: DataResponse<Any>  ) -> Int {
        if let httpError = response.result.error?._code {
            return httpError
        } else {
            return (response.response?.statusCode)!
        }
    }
    
    fileprivate func validateResponseSuccess(_ response: DataResponse<Any>) -> Bool {
        print("Request: \(response.request!)")
        let success = response.result.isSuccess && (self.getStatusCodeFrom(response) == 200)
        print(success ? "SUCCESS" : "FAILURE")
        return success
    }
    
    //API Calls
        
    func signIn(
        _ email: String,
        password: String,
        handler: @escaping (_ success: Bool, _ response: AnyObject?) -> Void
        )
    {
        let parameters: [String: String] = [
            "email": email as String,
            "password": password as String
        ]
        
        self.alamoFireManager.request(baseUrl+signInPath, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                let success = self.validateResponseSuccess(response)
                
                if (success)
                {
                    if let data = response.result.value as? [String : AnyObject] {
                        CurrentUser.sharedInstance.deserialize(data)
                    }
                    
                    handler(true, CurrentUser.sharedInstance)
                }
                else
                {
                    if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                    {
                        handler(false, error)
                    }
                    else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.NoInternet.rawValue
                    {
                        let error = HelloOmanError(errorCode: ErrorCode.NoInternet)
                        handler(false, error)
                        
                    } else {
                        let error = HelloOmanError()
                        error.detail = "Sign in server error"
                        handler(false, error)
                    }
                }
                
        }
    }
    
    
    func signInWithSocial(
        _ email: String,
        name: String,
        handler: @escaping (_ success: Bool, _ response: AnyObject?) -> Void
        )
    {
        let parameters: [String: String] = [
            "email": email as String,
            "name": name as String
        ]
        
        self.alamoFireManager.request(baseUrl+socialSignInPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                if let data = response.result.value as? [String : AnyObject] {
                    CurrentUser.sharedInstance.deserialize(data)
                }
                
                handler(true, CurrentUser.sharedInstance)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(false, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.NoInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.NoInternet)
                    handler(false, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Sign in server error"
                    handler(false, error)
                }
            }
            
        }
    }
    
    
    func signUp(
        _ email: String,
        name: String,
        phone: String,
        aganet_id: String,
        password: String,
        handler: @escaping (_ success: Bool, _ response: AnyObject?) -> Void
        )
    {
        let parameters: [String: String] = [
            "name": name as String,
            "email": email as String,
            "phone": phone as String,
            "agent_id": aganet_id as String,
            "password": password as String
        ]
        
        self.alamoFireManager.request(baseUrl+signUpPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                let success = self.validateResponseSuccess(response)
                
                if (success)
                {
                    if let data = response.result.value as? [String : AnyObject] {
                        CurrentUser.sharedInstance.deserialize(data)
                    }
                    
                    handler(true, CurrentUser.sharedInstance)
                }
                else
                {
                    if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                    {
                        handler(false, error)
                    } else {
                        let error = HelloOmanError()
                        error.detail = "Sign up server error"
                        handler(false, error)
                    }
                }
                
        }
    }
    
    func forgotPassword(
        _ phone: String,
        handler: @escaping (_ success: Bool, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: AnyObject] = [
            "phone": phone as AnyObject
        ]
        self.alamoFireManager.request(baseUrl+forgotPath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                let success = self.validateResponseSuccess(response)
                
                if (success)
                {
                    handler(true, nil)
                }
                else
                {
                    if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                    {
                        handler(false, error)
                    } else {
                        let error = HelloOmanError()
                        error.detail = "forgot password server error"
                        handler(false, error)
                    }
                }
        }
        
    }
    
    
    
    
   
    

}

