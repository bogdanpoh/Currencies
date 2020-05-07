//
//  CurrencyNetworkService.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

enum BankType {
    case privatBankOnline
    case privateBankOffline
    case monoBank
}

class CurrencyNetworkService {
    private init (){}
    
    static let instance = CurrencyNetworkService()
    
    var privatBankCurrency = [PrivatbankCurrencyModel]()
    var monoBankCurrency = [MonobankCurrencyModel]()
    
    func loadCurrency(bankType: BankType, completion: @escaping DownloadComplete){
        
        var urlCurrency: String = ""
        
        switch bankType {
        case .privatBankOnline:
            urlCurrency = privatApiOnlineCurrency
        case .privateBankOffline:
            urlCurrency = privatApiOfflineCurrency
        case .monoBank:
            urlCurrency = monobankApiCurrency
        }
        
        guard let url = URL(string: urlCurrency) else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                if bankType == .privatBankOnline || bankType == .privateBankOffline {
                    self.privatBankCurrency = try JSONDecoder().decode([PrivatbankCurrencyModel].self, from: data)
                    self.privatBankCurrency.removeLast()
                } else if bankType == .monoBank {
                    let currency = try JSONDecoder().decode([MonobankCurrencyModel].self, from: data)
                    
                    self.monoBankCurrency.removeAll()
                    
                    for i in 0 ..< 5 {
                        if i != 3 {
                            self.monoBankCurrency.append(currency[i])
                        }
                    }
                    
                }
                
                completion()
                
            } catch {
                print(error.localizedDescription)
                
                completion()
            }
            
        }
        
        task.resume()
    }
}
