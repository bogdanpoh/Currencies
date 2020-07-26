//
//  CurrencyNetworkService.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation

class CurrencyNetworkService {
    private init (){}
    
    static let instance = CurrencyNetworkService()
    
    var currentCurrency = [CurrencyModel]()
    
    func loadCurrency(bankType: BankType, completion: @escaping DownloadComplete, showError: @escaping ShowError){
        
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
                self.currentCurrency.removeAll()
                
                switch bankType {
                case .privatBankOnline, .privateBankOffline:
                    var privatBankCurrency = try JSONDecoder().decode([PrivatbankCurrencyModel].self, from: data)
                    privatBankCurrency.removeLast()
                    
                    privatBankCurrency.forEach { (privatCurrency) in
                        self.currentCurrency.append(CurrencyModel(privatBankModel: privatCurrency))
                    }
                case .monoBank:
                    let monobankCurrency = try JSONDecoder().decode([MonobankCurrencyModel].self, from: data)
                    
                    for i in 0 ..< 5 {
                        if i != 3 {
                            self.currentCurrency.append(CurrencyModel(monobankModel: monobankCurrency[i]))
                        }
                    }
                }
                
                completion()
                
            } catch {
                print(error.localizedDescription)
                
                
                showError()
            }
            
        }
        
        task.resume()
    }
}
