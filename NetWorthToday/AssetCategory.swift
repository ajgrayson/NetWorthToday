//
//  AssetCategory.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 6/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class AssetCategory {
    
    class var Fixed : (name: String, value: String) {
        return (name: "Fixed", value: "FIXED")
    }
    
    class var Liquid : (name: String, value: String) {
        return (name: "Liquid", value: "LIQUID")
    }
    
    class var Personal : (name: String, value: String) {
        return (name: "Personal", value: "PERSONAL")
    }
    
    class func getAll() -> [(name: String, value: String)] {
        
        return [Fixed, Liquid, Personal]
        
    }
    
    class func getIndexFor(asset : String) -> Int {
        
        var index : Int = 0
        for cat in [Fixed, Liquid, Personal] {
            if (asset == cat.value) {
                return index
            }
            index++
        }
        
        return -1
    }
    
    class func getCategoryForValue(asset: String?) -> (name: String, value: String)? {
        for cat in [Fixed, Liquid, Personal] {
            if(asset == cat.value) {
                return cat
            }
        }
        return nil
    }
}