//
//  ClickableItem.swift
//  ACCIF
//
//  Created by Dov Rosenberg on 9/2/17.
//  Copyright © 2017 Dov Rosenberg. All rights reserved.
//

import Foundation

class ClickableItem {
    var primaryKey:CLong
    var name:String
    var description:String
    var type:String
    var createDate:NSDate
    
    init(name:String, key:CLong, description:String){
        self.description = description
        self.primaryKey = key
        self.name = name
        self.type = "Clickable"
        createDate = NSDate()
    }
}
