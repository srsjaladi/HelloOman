//
//  HomeModel.swift
//  Hello Oman
//
//  Created by Sivaramsingh on 05/07/18.
//  Copyright © 2018 Self. All rights reserved.
//



import Foundation
import SwiftyJSON
struct HomeModel
{
    var travelIdeas = [TravelIdeasModel]()
    var countries = [CountriesModel]()
    var cities = [CitiesModel]()
    
    init() {
        
    }
    
    init(json:AnyObject?) {
        
        if let data = json {
            
            let travelArray = data["Travel_Ideas"] as! [AnyObject]
            for item in travelArray
            {
                travelIdeas.append(TravelIdeasModel(json: item))
            }
            let countriesArray = data["Countries"] as! [AnyObject]
            for item in countriesArray
            {
                countries.append(CountriesModel(json: item))
            }
            let citiesArray = data["Cities"] as! [AnyObject]
            for item in citiesArray
            {
                cities.append(CitiesModel(json: item))
            }
            
        }
    }
}

struct TravelIdeasModel
{
    var travelId = ""
    var travelTitle = ""
    var travelDesc = ""
    var travelImageUrl = ""
    var travelCategory = ""
    var travelIsFavourite = ""
    
    init() {
        
    }
    
    init(json:AnyObject?) {
        
        if let data = json {
            
            travelId = data["id"] as? String ?? ""
            travelTitle = data["title"] as? String ?? ""
            travelDesc = data["desc"] as? String ?? ""
            travelImageUrl = data["image"] as? String ?? ""
            travelCategory = data["category"] as? String ?? ""
            travelIsFavourite = data["fav"] as? String ?? ""
        }
    }
}

struct CountriesModel
{
    var countryId = ""
    var countryName = ""
    var countryImageUrl = ""
    
    init() {
        
    }
    
    init(json:AnyObject?) {
        
        if let data = json {
            
            countryId = data["id"] as? String ?? ""
            countryName = data["name"] as? String ?? ""
            countryImageUrl = data["image"] as? String ?? ""
            
        }
    }
}

struct CitiesModel
{
    var cityId = ""
    var cityName = ""
    var cityImageUrl = ""
    
    init() {
        
    }
    
    init(json:AnyObject?) {
        
        if let data = json {
            
            cityId = data["id"] as? String ?? ""
            cityName = data["name"] as? String ?? ""
            cityImageUrl = data["image"] as? String ?? ""
            
        }
    }
}


struct ThemeModel
{
    var id = ""
    var theme = ""
    
    init() {
        
    }
    
    init(object:AnyObject) {
        
        let json = JSON(object)
        
        self.id = json["id"].stringValue
        self.theme = json["theme"].stringValue
      
    }
}

