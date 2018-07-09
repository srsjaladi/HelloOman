//
//  KollectinError.swift
//  Kollectin
//
//  Created by Pablo on 1/5/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ErrorCode: Int
{

    case Default = 1
    case success = 200
    case successData = 201
    case NotRegistered = -2
    case InvalidPw = -1
    case error = 403
    case notFound = 404
    case badRequest = 400
    case tokenNotFound = 402
    case connectionFailed = 50
    case noInternet = 0
   
    
}

class HelloOmanError {
    var code: ErrorCode
    var title: String
    var detail: String
    
    init?(object: AnyObject)
    {
        let json = JSON(object)
        if let code = ErrorCode(rawValue: json["error_code"].intValue) {
            self.code = code
            self.title = json["message"].stringValue
            self.detail = json["detail"].stringValue
        } else {
            //TODO: Fix this next swift update
            self.code = .Default
            self.title = json["message"].stringValue
            self.detail = json["detail"].stringValue
        }
        
        self.printError()
    }
    
    init()
    {
        self.code = .Default
        self.title = "Error"
        self.detail = "An error has occurred. Please try again."
        
        self.printError()
    }

    init(errorCode: ErrorCode)
    {
        self.code = errorCode
        switch self.code {
        case .NotRegistered:
            self.title = "Oops!"
            self.detail = "Not a registered user."
            break
        case .InvalidPw:
            self.title = "Error"
            self.detail = "Invalid Password."
            break
        case .Default:
            self.title = "Error"
            self.detail = "No Error Code Returned."
            break
        case .error:
            self.title = "Error"
            self.detail = "Generic error."
            break
        case .notFound:
            self.title = "Error"
            self.detail = "Couldn't retrieve data."
            break
        case .badRequest:
            self.title = "Error"
            self.detail = "Couldn't retrieve data."
            break
        case .connectionFailed:
            self.title = "Error"
            self.detail = "Connection Failed. Please try again."
            break
        case .noInternet:
            self.title = "Error"
            self.detail = "No Internet."
            break
        default:
            self.title = "Error"
            self.detail = "An error has occurred. Please try again."
            break
        }
        
        self.printError()
    }
    
    func printError()
    {
        print("Error:")
        print("Title: \(self.title)")
        print("Detail: \(self.detail)")
        print("Code: \(self.code.rawValue)")
    }
    
}
