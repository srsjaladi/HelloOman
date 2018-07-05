//
//  CurrentUser+Manager.swift
//  Kollectin
//
//  Created by Pablo on 3/4/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation

extension CurrentUser
{
    func getUser(handler: ((_ user: User?) -> ())? )
    {
        self.load()
        if let handler = handler {
            handler(user)
        }
    }
}
