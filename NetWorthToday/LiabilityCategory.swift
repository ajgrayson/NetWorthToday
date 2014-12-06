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
    
}