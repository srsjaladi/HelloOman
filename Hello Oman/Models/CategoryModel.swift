//
//  PhotoArchiveStore.swift
//  Kollectin
//
//  Created by Sivaramsingh on 02/05/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import SwiftyJSON

private enum Keys: String {
    case id = "id"
    case ideas = "ideas"
    case category = "category"
}

class CategoryModel {
    
    var id: String
    var ideas: [IdeasModel] = [IdeasModel]()
    var category: String
    
    
    // For customer of
    init(id: String, ideas : [IdeasModel]?, category: String ) {
        
        self.id = id
        self.category = category
        if ideas != nil {
            self.ideas = ideas!
        }
        
    }
}

extension CategoryModel {
    
    static func deserialize(_ dictionary: [String: AnyObject]) -> CategoryModel?
    {
        let id = dictionary[Keys.id.rawValue] as? String ?? ""
        let category = dictionary[Keys.category.rawValue] as? String ?? ""
        
        var ideas = [IdeasModel]()
        if let ideasObj = dictionary[Keys.ideas.rawValue]
        {
            let json = JSON(ideasObj)
            let ideasArray = json.arrayValue
            for item in ideasArray {
                let IdeaModel = IdeasModel(object: item.object as AnyObject)
                ideas.append(IdeaModel)
            }
        }
        
        return CategoryModel(id: id, ideas: ideas, category: category)
    }
    
}

