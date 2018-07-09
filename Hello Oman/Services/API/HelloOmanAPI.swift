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
                    else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                    {
                        let error = HelloOmanError(errorCode: ErrorCode.noInternet)
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
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
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
    
    func getHomeDetails(
        _ userId: String,
        handler: @escaping (_ homeDetails: HomeModel?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": userId as String
        ]
        
        self.alamoFireManager.request(baseUrl+homeDetails, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let data = response.result.value
                let homeData = HomeModel(json: data as AnyObject)
                
                handler(homeData,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Home Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    
    func getAllPackages(
        _ userId: String,
        agentId: String,
        start: Int,
        handler: @escaping (_ response: AnyObject?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: Any] = [
            "user_id": userId  as String,
            "agent_id": agentId as String,
            "start": start as Int
        ]
        
        self.alamoFireManager.request(baseUrl+packgesDetails, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let objectList = response.result.value as! [String : AnyObject]
                let packgesData = PackagesModelList.deserialize(objectList)
                handler(packgesData as AnyObject,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "packages Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    
    func callingChangePasswordAPI(
        _ email: String,
        old: String,
        confirm: String,
        handler: @escaping (_ response: String?, _ responseCode: String, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "email": email  as String,
            "old": old as String,
            "confirm": confirm as String
        ]
        
        self.alamoFireManager.request(baseUrl+ChangePasswordPath, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                print(responseText)
                handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler("","", error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler("","", error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "change Password server error"
                    handler("","", error)
                }
            }
            
        }
    }
    
    func callingUpdatedAccountAPI(
        _ user_id: String,
        name: String,
        email: String,
        phone: String,
        agent_id: String,
        handler: @escaping (_ response: String?, _ responseCode: String, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": user_id  as String,
            "name": name as String,
            "email": email as String,
            "phone": phone as String,
            "agent_id": agent_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+updateAccountPath, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                print(responseText)
                handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler("","", error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler("","", error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Updating profile server error"
                    handler("","", error)
                }
            }
            
        }
    }
    
    func getAgentDetails(
        _ unique_id: String,
        handler: @escaping (_ success: Bool,_ response: String?, _ responseCode: String,_ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "unique_id": unique_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+getAgentPath, method: .get, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                let responseObject = JSON(responseText["Response"].object as AnyObject)
                print(responseObject)
                
                if  responseObject["response_code"].stringValue == "1"
                {
                    if let data = response.result.value as? [String : AnyObject] {
                        CurrentUser.sharedInstance.agentDeserialize(data)
                        CurrentUser.sharedInstance.save()
                    }
                }
            handler(true ,responseObject["response"].stringValue,responseObject["response_code"].stringValue,nil)
                
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(false, "","",error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(false, "","",error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Agent Details server error"
                    handler(false, "","",error)
                }
            }
            
        }
    }

    func ChangeProfilImage(
        userId: String?,
        ProfilePicture: UIImage?,
        handler: @escaping (_ response: String?, _ responseCode: String, _ error: HelloOmanError?) -> Void
        )
    {
        let URLString = baseUrl+uPdateImagePAth
       
        var dataImage: Data? = nil
        if let image = ProfilePicture {
            dataImage = UIImageJPEGRepresentation(image, 0.2)
        }
        
        var dataUserId: Data? = nil
        if let userId = userId {
            dataUserId = userId.data(using: String.Encoding.utf8)
        }
        
        self.alamoFireManager.upload(multipartFormData: { (multipartFormData ) in
            
            if let dataUserId = dataUserId {
                multipartFormData.append(dataUserId, withName: "user_id")
                
                if let dataImage = dataImage {
                    multipartFormData.append(dataImage, withName: "ProfilePicture", fileName: "ImageniOS.jpeg", mimeType: "image/jpeg")
                }
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: URLString, method: .post) { encodingResult in
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) -> Void in
                    let success = self.validateResponseSuccess(response)
                    
                    if (success)
                    {
                        let responseText = JSON(response.result.value as AnyObject)
                        print(responseText)
                        handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
                    }
                    else
                    {
                        if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                        {
                            handler("","",error)
                        }
                        else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                        {
                            let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                            handler("","",error)
                            
                        } else {
                            let error = HelloOmanError()
                            error.detail = "Agent Details server error"
                            handler("","",error)
                        }
                    }
                })
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    
    
   
    func getTravelPlansDetails(
        user_id: String,
        handler: @escaping (_ travelIdeasList: [CategoryModel], _ error: HelloOmanError?) -> Void
        )
    {
        
        let parameters: [String: String] = [
            "user_id": user_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+travelPlansDetails, method: .post, parameters: parameters).responseJSON { response in
                
                let success = self.validateResponseSuccess(response)
                
                if (success)
                {
                    var allTravelPlanList = [CategoryModel]()
                    let object = JSON(response.result.value as AnyObject)
                    let arrCategory = object["TravelCategories"].arrayValue
                    for item in arrCategory
                    {
                        let allCategoryList = CategoryModel.deserialize(item.object as! [String : AnyObject])
                        allTravelPlanList.append(allCategoryList!)
                    }
                    handler(allTravelPlanList, nil)
                }
                else
                {
                    if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                    {
                        handler([], error)
                    } else {
                        let error = HelloOmanError()
                        error.detail = "Travel Plans API Error"
                        handler([], error)
                    }
                }
                
        }
    }
    
    func getAllFavouritePackages(
        _ userId: String,
        handler: @escaping (_ response: AnyObject?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: Any] = [
            "user_id": userId  as String
        ]
        
        self.alamoFireManager.request(baseUrl+favouritePackgesDetails, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let objectList = response.result.value as! [String : AnyObject]
                let packgesData = PackagesModelList.deserialize(objectList)
                handler(packgesData as AnyObject,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Favoutie packages Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    func getFavouriteTravelPlansDetails(
        user_id: String,
        handler: @escaping (_ travelIdeasList: [TravelIdeasModel], _ error: HelloOmanError?) -> Void
        )
    {
        
        let parameters: [String: String] = [
            "user_id": user_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+favouriteTravelIdeaDetails, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let object = JSON(response.result.value as AnyObject)
                let travelArray = object["Travel_Ideas"].arrayValue
                var travelIdeasList = [TravelIdeasModel]()
                for item in travelArray
                {
                    travelIdeasList.append(TravelIdeasModel(json: item.object as AnyObject))
                }
                handler(travelIdeasList, nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler([], error)
                } else {
                    let error = HelloOmanError()
                    error.detail = "Travel Ideas API Error"
                    handler([], error)
                }
            }
            
        }
    }
    
    func getAllPackagesFromMore(
         _ userId: String,
        agentId: String,
        type: String,
        search: String,
        handler: @escaping (_ response: AnyObject?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": userId  as String,
            "agent_id": agentId as String,
            "type": type as String,
            "search": search as String
        ]
        
        self.alamoFireManager.request(baseUrl+morePackgesDetails, method: .post, parameters:parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let objectList = response.result.value as! [String : AnyObject]
                let packgesData = PackagesModelList.deserialize(objectList)
                handler(packgesData as AnyObject,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "packages Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    func getMoreTravelPlansDetails(
        user_id: String,
        categoryid : String,
        handler: @escaping (_ travelIdeasList: [TravelIdeasModel], _ error: HelloOmanError?) -> Void
        )
    {
        
        let parameters: [String: String] = [
            "user_id": user_id as String,
            "category": categoryid as String
        ]
        
        self.alamoFireManager.request(baseUrl+moreTravelIdeaDetails, method: .post, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let object = JSON(response.result.value as AnyObject)
                let travelArray = object["Travel_Ideas"].arrayValue
                var travelIdeasList = [TravelIdeasModel]()
                for item in travelArray
                {
                    travelIdeasList.append(TravelIdeasModel(json: item.object as AnyObject))
                }
                handler(travelIdeasList, nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler([], error)
                } else {
                    let error = HelloOmanError()
                    error.detail = "Travel Ideas API Error"
                    handler([], error)
                }
            }
            
        }
    }
    
    func getItineraryDetails(
        _ package_id: String,
        handler: @escaping (_ ItineraryModelList :[ItineraryModel]?,_ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "package_id": package_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+getItineryDetails, method: .get, parameters: parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = response.result.value! as! [AnyObject]
                var arrItineraryLsit = [ItineraryModel]()
                for item in responseText
                {
                    let objItinerary = ItineraryModel(object: item as AnyObject)
                    arrItineraryLsit.append(objItinerary)
                }
                handler(arrItineraryLsit,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil,error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil,error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Iteinerary Details server error"
                    handler(nil,error)
                }
            }
            
        }
    }
    
    func getAllDetailedTravelDetails(
        _ userId: String,
        agentId: String,
        travel_id: String,
        handler: @escaping (_ responseList: [DetailedTravelItemsModel]?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": userId  as String,
            "agent_id": agentId as String,
            "travel_id": travel_id as String
        ]
        
        self.alamoFireManager.request(baseUrl+getITravelDetails, method: .post, parameters:parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                var allTravelDetailsList = [DetailedTravelItemsModel]()
                let object = JSON(response.result.value as AnyObject)
                let arrCategory = object["TravelDetails"].arrayValue
                for item in arrCategory
                {
                    let allCategoryList = DetailedTravelItemsModel.deserialize(item.object as! [String : AnyObject])
                    allTravelDetailsList.append(allCategoryList!)
                }
                
                handler(allTravelDetailsList,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "packages Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    
    func getThemeDetails(
        _
        handler: @escaping (_ responseList: [ThemeModel]?, _ error: HelloOmanError?) -> Void
        )
    {
       
        self.alamoFireManager.request(baseUrl+getIFilterDetails, method: .post, parameters:nil).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                var allThemeList = [ThemeModel]()
                let object = JSON(response.result.value as AnyObject)
                let arrCategory = object["Themes"].arrayValue
                for item in arrCategory
                {
                    let theme = ThemeModel(object:item.object as AnyObject)
                    allThemeList.append(theme)
                }
                
                handler(allThemeList,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler(nil, error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler(nil, error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Themes Details server error"
                    handler(nil, error)
                }
            }
            
        }
    }
    
    
    func UpdateFavoritedForPackages(
        _ userId: String,
        package_id: String,
        option: String,
        handler: @escaping (_ response: String?, _ responseCode: String?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": userId  as String,
            "package_id": package_id as String,
            "option": option as String
        ]
        
        self.alamoFireManager.request(baseUrl+getIFavoriteForPackages, method: .post, parameters:parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                print(responseText)
                handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler("","", error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler("","", error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Favorited server error"
                    handler("","", error)
                }
            }
            
        }
    }
    
    
    func UpdateFavoritedForTravelItems(
        _ userId: String,
        travel_id: String,
        option: String,
        handler: @escaping (_ response: String?, _ responseCode: String?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "user_id": userId  as String,
            "travel_id": travel_id as String,
            "option": option as String
        ]
        
        self.alamoFireManager.request(baseUrl+getIFavoriteForTravelIdeas, method: .post, parameters:parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                print(responseText)
                handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler("","", error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler("","", error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Favorited server error"
                    handler("","", error)
                }
            }
            
        }
    }

    
    
    func sendRequestForPLan(
        _ name: String,
        email: String,
        phone: String,
        country: String,
        dep: String,
        arr: String,
        persons: String,
        budget: String,
        duration: String,
        agent_email: String,
        subject: String,
        image: String,
        handler: @escaping (_ response: String?, _ responseCode: String?, _ error: HelloOmanError?) -> Void
        )
    {
        let parameters: [String: String] = [
            "name": name  as String,
            "email": email as String,
            "phone": phone as String,
            "country": country  as String,
            "dep": dep as String,
            "arr": arr as String,
            "persons": persons  as String,
            "budget": budget as String,
            "duration": duration as String,
            "agent_email": persons  as String,
            "subject": budget as String,
            "image": duration as String,
        ]
        
        self.alamoFireManager.request(baseUrl+getRequestForPlan, method: .post, parameters:parameters).responseJSON { response in
            
            let success = self.validateResponseSuccess(response)
            
            if (success)
            {
                let responseText = JSON(response.result.value as AnyObject)
                print(responseText)
                handler(responseText["response"].stringValue,responseText["response_code"].stringValue,nil)
            }
            else
            {
                if let value = response.result.value, let error = HelloOmanError(object: value as AnyObject)
                {
                    handler("","", error)
                }
                else if let errorCode = response.response?.statusCode, errorCode == ErrorCode.noInternet.rawValue
                {
                    let error = HelloOmanError(errorCode: ErrorCode.noInternet)
                    handler("","", error)
                    
                } else {
                    let error = HelloOmanError()
                    error.detail = "Favorited server error"
                    handler("","", error)
                }
            }
            
        }
    }
}

