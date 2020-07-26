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
    
    //MARK: - Properties
    static let instance = DatabaseManager()
    
    var currencies = [Currency]()
    
    //MARK: - Methods
    func saveCurrency(_ currency: CurrencyModel, type: BankType) {
        loadData(complete: nil)
        
        let newCurrency = Currency(context: PersistenceService.context)
        
        newCurrency.name = currency.ccy
        newCurrency.buy = String(describing: currency.buy)
        newCurrency.sale = String(describing: currency.sell)
        newCurrency.date = currency.date
        
        switch type {
        case .privatBankOnline:
            newCurrency.source = privatSourceName
        case .privateBankOffline:
            newCurrency.source = privatOfflineSourceName
        case .monoBank:
            newCurrency.source = monoSouceName
        }
        
        currencies.append(newCurrency)
        PersistenceService.saveContext()
    }
    
    func saveData(type: BankType, complete: SaveComplete?) {
        
        loadData(complete: nil)
        
        switch type {
        case .privatBankOnline, .privateBankOffline:
            let currencyPrivat = CurrencyNetworkService.instance.currentCurrency
            
            currencyPrivat.forEach { (item) in
                let currency = Currency(context: PersistenceService.context)
                
                currency.buy = String(describing: item.buy)
                currency.sale = String(describing: item.sell)
                currency.source = type == .privatBankOnline ? privatSourceName : privatOfflineSourceName
                currency.date = getCurrentDate()
                currency.name = item.ccy
                
                currencies.append(currency)
                PersistenceService.saveContext()
            }
        case .monoBank:
            let currencyMono = CurrencyNetworkService.instance.currentCurrency
            
            currencyMono.forEach { (item) in
                let currency = Currency(context: PersistenceService.context)
                
                currency.buy = String(describing: item.buy)
                currency.sale = String(describing: item.sell)
                currency.source = monoSouceName
                currency.date = getCurrentDate()
                currency.name = item.ccy
                
                currencies.append(currency)
                PersistenceService.saveContext()
            }
        }
        
        complete?()
        
    }
    
    func loadData(complete: LoadComplete?) {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            let data = try PersistenceService.context.fetch(fetchRequest)
            
            currencies = []
            
            let sourceName = getCurrentSourceName()
            
            data.forEach { (currency) in
                if currency.source == sourceName {
                    currencies.append(currency)
                }
            }
            
            currencies.sort { DatabaseManager.instance.compareDate($0, $1) }
            
            complete?()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadLastData(complete: LoadComplete?) {
        
        self.currencies.removeAll()
        
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            
            let data = try PersistenceService.context.fetch(fetchRequest)
            
            var dates: Set<String> = []
            var sortDates = [String]()
            
            let sourceName = getCurrentSourceName()
            
            data.forEach { (currency) in
                dates.insert(currency.date ?? "")
            }
            
            dates.forEach { (date) in
                sortDates.append(date)
            }
            
            sortDates.sort{ DatabaseManager.instance.compareDate($0, $1) }
            
            guard let firstDate = sortDates.first else { return }
            
            print(sortDates)
            
            data.forEach { (currency) in
                
                if let date = currency.date {
                    if currency.source == sourceName && date == firstDate {
                        currencies.append(currency)
                    }
                }
            }
            
            //            if let firstDate = sortDates.first {
            //                data.forEach { (currency) in
            //                    if currency.date == firstDate && sourceName == currency.source {
            //                        currencies.append(currency)
            //                    }
            //                }
            //            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        complete?()
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
