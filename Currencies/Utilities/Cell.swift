//
//  Cell.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation
import UIKit

class Cell {
    private init() {}
    
    static let instance = Cell()
    
    func setBorderImage(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    func formatCurrency(number: Double) -> String {
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
        var value: String = "\(NSDecimalNumber(value: number).rounding(accordingToBehavior: behavior))"
        
        if value.split(separator: ".").last!.count == 1 {
            value = value + "0"
        }
        
        if value.split(separator: ".").last! == value {
            value = value + ".00"
        }
        
        return value
    }
    
    func getCellImage(currencyName: String) -> UIImage? {
        let name = currencyName.lowercased()
        
        guard let defaultImage = UIImage(named: "ukr-flag") else { return nil }
        
        switch name {
        case "usd":
            return UIImage(named: "usd-flag")
        case "eur":
            return UIImage(named: "eur-flag")
        case "rur":
            return UIImage(named: "rur-flag")
        case "pln":
            return UIImage(named: "pln-flag")
        default:
            return defaultImage
        }
    }
    
//    func getCellImage(currencyName: String, currencyType: BankType) -> UIImage? {
//
//        guard let defaultImage = UIImage(named: "ukr-flag") else { return nil }
//
//        switch currencyType {
//        case .privatBankOnline, .privateBankOffline:
//            let name = currencyName.lowercased()
//
//            switch name {
//            case "usd":
//                return UIImage(named: "usd-flag")
//            case "eur":
//                return UIImage(named: "eur-flag")
//            case "rur":
//                return UIImage(named: "rur-flag")
//            default:
//                return defaultImage
//            }
//
//        case .monoBank:
//            var name: String = ""
//
//            currencyCode.forEach { (key, value) in
//                if currencyName == key || currencyName == value {
//                    name = value
//                }
//            }
//
//            return UIImage(named: name.lowercased()+"-flag")
//        }
//
//    }
}
