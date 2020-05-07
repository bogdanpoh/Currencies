//
//  Constans.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

let privatApiOnlineCurrency = "https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11"
let privatApiOfflineCurrency = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
let monobankApiCurrency = "https://api.monobank.ua/bank/currency"

let currencyCode = ["840" : "USD", "978" : "EUR", "643" : "RUR", "985" : "PLN"]

let privatOnlineKey = "privatOnlineKey"
let privatOfflineKey = "privatOfflineKey"
let monobankKey = "monobankKey"

let privatSourceName = "PrivatBank"
let privatOfflineSourceName = "PrivatBankOffline"
let monoSouceName = "Monobank"

let dateFormat = "dd.MM.yyyy"

typealias DownloadComplete = () -> ()
typealias SaveComplete = () -> ()
