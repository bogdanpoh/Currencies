//
//  CurrencyModel.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 29.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

class CurrencyModel {
    
    var ccy, baseCcy, date: String
    var buy, sell: Double
    
    init(monobankModel: MonobankCurrencyModel) {
        self.ccy = currencyCode[String(describing: monobankModel.currencyCodeA)] ?? ""
        self.baseCcy = currencyCode[String(describing: monobankModel.currencyCodeB)] ?? ""
        self.buy = monobankModel.rateBuy ?? 0.0
        self.sell = monobankModel.rateSell ?? 0.0
        self.date = DatabaseManager.instance.getCurrentDate()
    }
    
    init(privatBankModel: PrivatbankCurrencyModel) {
        self.ccy = privatBankModel.ccy
        self.baseCcy = privatBankModel.ccy
        self.buy = Double(privatBankModel.buy) ?? 0.0
        self.sell = Double(privatBankModel.sale) ?? 0.0
        self.date = DatabaseManager.instance.getCurrentDate()
    }
}
