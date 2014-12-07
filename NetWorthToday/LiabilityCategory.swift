//
//  LiabilityCategory.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 6/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class LiabilityCategory {
    
    class var ShortTerm : (name: String, value: String) {
        return (name: "Short Term", value: "SHORTTERM")
    }
    
    class var LongTerm : (name: String, value: String) {
        return (name: "Long Term", value: "LONGTERM")
    }
    
    class func getAll() -> [(name: String, value: String)] {
        
        return [ShortTerm, LongTerm]
        
    }
    
    class func getIndexFor(asset : String) -> Int {
        
        var index : Int = 0
        for cat in [ShortTerm, LongTerm] {
            if (asset == cat.value) {
                return index
            }
            index++
        }
        
        return -1
    }
    
    class func getCategoryForValue(asset: String?) -> (name: String, value: String)? {
        for cat in [ShortTerm, LongTerm] {
            if(asset == cat.value) {
                return cat
            }
        }
        return nil
    }
    
}