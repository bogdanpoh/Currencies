//
//  DateCurrency.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 28.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

class DateCurrency {
    
    var date: String
    var currencies = [Currency]()
    
    init(date: String, currencies: [Currency]) {
        self.date = date
        self.currencies = currencies
    }
    
}
