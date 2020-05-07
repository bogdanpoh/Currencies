//
//  PrivatbankCurrencyModel.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

struct PrivatbankCurrencyModel: Codable {
    let ccy, baseCcy, buy, sale: String

    enum CodingKeys: String, CodingKey {
        case ccy
        case baseCcy = "base_ccy"
        case buy, sale
    }
}
