//
//  DatabaseViews.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 8/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class DatabaseViews {
 
    class var ViewName_Items : String {
        return "items"
    }
    
    class var ViewName_Assets : String {
        return "assets"
    }
    
    class var ViewName_Liabilities : String {
        return "liabilities"
    }
    
    class func createItemsView(database: CBLDatabase) {
        database.viewNamed(ViewName_Items).setMapBlock({
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            if (type == "item") {
                
                if let nameObj: AnyObject = doc["name"] {
                    
                    if let name = nameObj as? String {
                        emit(name, doc)
                    }
                    
                }
                
            }
            
        }, version: "2")
    }
    
    class func createAssetsAndLiabilityViews(database: CBLDatabase) {
        database.viewNamed(ViewName_Assets).setMapBlock({
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            if (type == "item") {
                
                let itemType : String? = doc["itemType"] as String?
                if (ItemType(rawValue: itemType!) == ItemType.Asset) {
                    
                    if let nameObj: AnyObject = doc["name"] {
                        
                        if let name = nameObj as? String {
                            emit(name, doc)
                        }
                        
                    }
                    
                }
                
            }
            
        }, version: "2")
        
        database.viewNamed(ViewName_Liabilities).setMapBlock({
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            if (type == "item") {
                
                let itemType : String? = doc["itemType"] as String?
                if (ItemType(rawValue: itemType!) == ItemType.Liability) {
                    
                    if let nameObj: AnyObject = doc["name"] {
                        
                        if let name = nameObj as? String {
                            emit(name, doc)
                        }
                        
                    }
                    
                }
                
            }
            
        }, version: "2")
    }
    
    class func getViewNameForItemType(itemType : ItemType) -> String {
        if(itemType == ItemType.Asset) {
            return ViewName_Assets
        } else {
            return ViewName_Liabilities
        }
    }
    
}