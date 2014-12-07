//
//  ItemType.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 6/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import Foundation

enum ItemType : String {
    
    case Asset = "ASSET"
    
    case Liability = "LIABILITY"
    
    var description : String {
        switch self {
        case .Asset: return "Asset"
        case .Liability: return "Liability"
        }
    }
    
}