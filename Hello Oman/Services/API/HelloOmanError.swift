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
    case ComingSoon = 2
    case ContactNoEmail = 3
    case TokenExpired = 200002
    case SignUpGeneric = 100000
    case SignUpNoInvites = 100011
    case SignUpNoCodeInvites = 100012
    case SignUpNoValidCode = 100013
    case SignUpInvalidEmail = 100001
    case SignUpCurrenPasswordInvalid = 100003
    case CancelAccountError = 100005
    case SignInInvalidCredentials = 200001
    case CreateStoreError = 400000
    case GetStoresError = 400001
    case NameStoreAlreadyUsed = 400005
    case GetColorPalettesError = 500001
    case OrderItemsOOSCart = 1200001
    case RedeemPointsNotEnough = 1400002
    case AddCartStockError = 600001
    case NoEmailForgotPassword = 2100003
    case InvalidCoupon = 1600001
    case NoInternet = -1009
    case InvalidEmail = 300006
    case ExpiredCoupon = 100004
    case OneTimeCouponAlreadyUsed = 1600007
    case NeedToEnterAny = 2600000
    case CodeAlreadyUsed = 2600001
    case emailAlreadyUsed = 2600002
    case InviteSearchingCodeError = 2600003
    case InviteSearchinhEmailError = 2600004
    case InviteEmailError = 2600005
    case InviteSearchingOldEmailError = 2600006
    case InviteExistingEmailError = 2600007
   
    
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
        case .ComingSoon:
            self.title = "Opps!"
            self.detail = "Feature coming soon!"
            break
        case .ContactNoEmail:
            self.title = "Error"
            self.detail = "Contact doesn't have an email. Code:3"
            break
        case .Default:
            self.title = "Error"
            self.detail = "No Error Code Returned."
            break
        case .TokenExpired:
            self.title = "Error"
            self.detail = "Token expired. Error Code 200002"
            break
        case .SignUpGeneric:
            self.title = "Error"
            self.detail = "Generic signup error. Error Code 100000."
            break
        case .SignUpInvalidEmail:
            self.title = "Error"
            self.detail = "Invalid email. Error Code 100001."
            break
        case .SignUpCurrenPasswordInvalid:
            self.title = "Error"
            self.detail = "Invalid current password. Error Code 100003."
            break
        case .CancelAccountError:
            self.title = "Error"
            self.detail = "Cancel account error. Error Code 100005."
            break
        case .SignInInvalidCredentials:
            self.title = "Error"
            self.detail = "Invalid Credentials. Error Code 200001."
            break
        case .NameStoreAlreadyUsed:
            self.title = "Error"
            self.detail = "Store name already used. Error Code 400005."
            break
        case .GetColorPalettesError:
            self.title = "Error"
            self.detail = "Couldn't retrieve color palettes. Error Code 500001."
            break
        case .OrderItemsOOSCart:
            self.title = "Error"
            self.detail = "Items out of stock. Error Code 1200001."
            break
        case .RedeemPointsNotEnough:
            self.title = "Error"
            self.detail = "Low redeem points. Error Code 1400002."
            break
        case .AddCartStockError:
            self.title = "Error"
            self.detail = "Add cart error. Error Code 600001."
            break
        case .NoEmailForgotPassword:
            self.title = "Error"
            self.detail = "Email forgot error. Error Code \(ErrorCode.NoEmailForgotPassword.rawValue)."
            break
        case .InvalidCoupon:
            self.title = "Error"
            self.detail = "Invalid Cupon. Error Code 1600001."
            break
        case .NoInternet:
            self.title = "Error"
            self.detail = "No internet connection."
            break
        case .InvalidEmail:
            self.title = "Error"
            self.detail = "Invalid Email."
            break
        case .ExpiredCoupon:
            self.title = "Error"
            self.detail = "Invalid Cupon."
            break
        case .OneTimeCouponAlreadyUsed:
            self.title = "Error"
            self.detail = "One time Coupon already used."
            break
        case .SignUpNoCodeInvites:
            self.title = "Error"
            self.detail = "Error while searching code"
            break
        case .SignUpNoValidCode:
            self.title = "Error"
            self.detail = "Not a valid access code"
            break
        case .NeedToEnterAny:
            self.title = "Error"
            self.detail = "Only one of code or email must be sent"
            break
        case .CodeAlreadyUsed:
            self.title = "Error"
            self.detail = "Code invite validation is already tried"
            break
        case .emailAlreadyUsed:
            self.title = "Error"
            self.detail = "Email invite validation is already tried"
            break
        case .InviteSearchingCodeError:
            self.title = "Error"
            self.detail = "Error while searching code"
            break
        case .InviteSearchinhEmailError:
            self.title = "Error"
            self.detail = "Error while searching email"
            break
        case .InviteEmailError:
            self.title = "Error"
            self.detail = "Invalid Email"
            break
        case .InviteSearchingOldEmailError:
            self.title = "Error"
            self.detail = "Error while searching for existing user"
            break
        case .InviteExistingEmailError:
            self.title = "Error"
            self.detail = "A user with that email already exists"
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
