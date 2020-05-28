//
//  HistoryTableViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    let identifier = "HistoryTableViewCell"
    
    var currentDates = [String]()
    
    var dateCurrenies = [DateCurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        DatabaseManager.instance.loadData {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentDates = []
        self.dateCurrenies = []
        
        DatabaseManager.instance.loadData {
            
            OperationQueue.main.addOperation {
                
                var dates: Set<String> = []
                
                let currencies = DatabaseManager.instance.currencies
                
                for currency in currencies {
                    if let date = currency.date {
                        dates.insert(date)
                    }
                }
                
                for data in dates {
                    self.currentDates.append(data)
                }
                
                self.currentDates.sort{ DatabaseManager.instance.compareDate($0, $1)}
                
                self.sortCurrencyOfSection(self.currentDates, currencies)
            
                self.tableView.reloadData()
            }
        }
    
    }
    
    func sortCurrencyOfSection(_ dates: [String], _ currencies: [Currency]) {
        
        dates.forEach { (date) in

            var sortedCurrencies = [Currency]()

            currencies.forEach { (currency) in

                guard let currencyDate = currency.date else { return }
                
                if date == currencyDate {
                    sortedCurrencies.append(currency)
                }

            }

            self.dateCurrenies.append(DateCurrency(date: date, currencies: sortedCurrencies))

        }
    }
    
}

extension HistoryTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dateCurrenies.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dateCurrenies[section].date
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateCurrenies[section].currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HistoryTableViewCell
        
        let currency = dateCurrenies[indexPath.section].currencies[indexPath.row]
        
        cell.setupCell(currency: currency)
        cell.selectionStyle = .none
        
        return cell
    }
    
}
