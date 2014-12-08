//
//  Formatting.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 8/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

class Formatting {
    
    class func formatMoney(val : Int?) -> String {
        if(val == nil) {
            return ""
        }
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.maximumFractionDigits = 0
        
        var str = currencyFormatter.stringFromNumber(val!)
        
        return str != nil ? str! : ""
    }
    
    class func formatMoney(val : NSNumber?) -> String {
        if(val == nil) {
            return ""
        }
        
        var intVal : Int = val!.integerValue
        
        return formatMoney(intVal)
    }
    
}