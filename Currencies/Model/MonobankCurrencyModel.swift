//
//  MonobankCurrencyModel.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

struct MonobankCurrencyModel: Codable {
    let currencyCodeA, currencyCodeB, date: Int
    let rateBuy, rateSell, rateCross: Double?
}
