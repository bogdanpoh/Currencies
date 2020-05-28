//
//  DatabaseManager.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 07.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    static let instance = DatabaseManager()
    
    var currencies = [Currency]()
    var currentDateCurrencies = [Currency]()
    
    func saveData(type: BankType, complete: SaveComplete?) {
        
        loadData(complete: nil)
        
        switch type {
        case .privatBankOnline, .privateBankOffline:
//            let currencyPrivat = CurrencyNetworkService.instance.privatBankCurrency
            let currencyPrivat = CurrencyNetworkService.instance.currentCurrency
            
            currencyPrivat.forEach { (item) in
                let currency = Currency(context: PersistenceService.context)
                
                currency.buy = String(describing: item.buy)
                currency.sale = String(describing: item.sell)
                currency.source = type == .privatBankOnline ? privatSourceName : privatOfflineSourceName
                currency.name = item.ccy
                currency.date = getCurrentDate()
                
                currencies.append(currency)
                PersistenceService.saveContext()
            }
        case .monoBank:
//            let currencyMono = CurrencyNetworkService.instance.monoBankCurrency
            let currencyMono = CurrencyNetworkService.instance.currentCurrency
            
            currencyMono.forEach { (item) in
                let currency = Currency(context: PersistenceService.context)
                
//                guard let buy = item.rateBuy else { return }
//                guard let sale = item.rateSell else { return }
                
                currency.buy = String(describing: item.buy)
                currency.sale = String(describing: item.sell)
                currency.source = monoSouceName
                currency.date = getCurrentDate()
                currency.name = item.ccy
                
//                if let name = currencyCode[String(describing: item.currencyCodeA)] {
//                    currency.name = name
//                }
                currencies.append(currency)
                PersistenceService.saveContext()
            }
        }
        complete?()
    }
    
    func loadData(complete: SaveComplete?) {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            let data = try PersistenceService.context.fetch(fetchRequest)
            //            self.currencies = data
            currencies = []
            
            var source: String
            
            switch activeBankType {
            case .privatBankOnline:
                source = privatSourceName
            case .privateBankOffline:
                source = privatOfflineSourceName
            case .monoBank:
                source = monoSouceName
            }
            data.forEach { (currency) in
                if currency.source == source {
                    currencies.append(currency)
                }
                
                if currency.date == getCurrentDate() {
                    currentDateCurrencies.append(currency)
                }
            }
            
            currencies.sort { DatabaseManager.instance.compareDate($0, $1) }
            
            complete?()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAllData() {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            let data = try PersistenceService.context.fetch(fetchRequest)
            
            data.forEach { (item) in
                PersistenceService.context.delete(item)
                PersistenceService.saveContext()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        
        format.dateFormat = dateFormat
        
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func compareDate(_ first: Currency, _ second: Currency) -> Bool {
        
        let firstDateString = first.date ?? ""
        let secondDateString = second.date ?? ""
        
        return compareStringDate(firstDateString, secondDateString)
    }
    
    func compareDate(_ first: String, _ second: String) -> Bool {
        
        return compareStringDate(first, second)
    }
    
    private func compareStringDate(_ first: String, _ second: String) -> Bool {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        
        if let firstDate = dateFormatter.date(from: first), let secondDate = dateFormatter.date(from: second) {
            return firstDate > secondDate
        }
        
        return false
    }
}
