//
//  SharedVar.swift
//  EUR
//
//  Created by Eruqul on 11/10/20.
//  Copyright © 2019 mrb. All rights reserved.
//

import Foundation

class SharedVar {
    static let sharedInstance = SharedVar()
    
    var fCurrency: [Float]// EUR, USD, GBP, DKK, SEK
    var fSelected: Int
    private init() {
        fCurrency = [0.0, 0.0, 0.0, 0.0, 0.0]
        fSelected = 0
    }
    
    public func setCurrency(cur: [Float]) {
        fCurrency = cur
    }
    
    public func getCurrency() -> Float {
        return fCurrency[fSelected]
    }
    
    public func setIndex(idx: Int) {
        fSelected = idx
    }
    
    public func getIndex() -> Int {
        return fSelected
    }
    
    public func getCurrencyStr() -> String {
        switch fSelected {
        case 0:
            return "€ " + String(getCurrency())
        case 1:
            return "$ " + String(getCurrency())
        case 2:
            return "£ " + String(getCurrency())
        case 3:
            return "Kr " + String(getCurrency())
        case 4:
            return "SEK " + String(getCurrency())
        default:
            return ""
        }
    }
}
