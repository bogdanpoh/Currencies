//
//  CurrentViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit
import JGProgressHUD

class CurrentTableViewController: UITableViewController {
    
    let identifier = "CurrencyTableViewCell"
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    
        hud.show(in: self.view)
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType){
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.hud.dismiss(animated: true)
//                DatabaseManager.instance.saveData(type: activeBankType, complete: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hud.show(in: self.view)
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType) {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.hud.dismiss(animated: true)
            }
        }
        
    }
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType) {
            OperationQueue.main.addOperation {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                DatabaseManager.instance.saveData(type: activeBankType, complete: nil)
            }
        }
        
    }
    
}

extension CurrentTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        switch activeBankType {
        case .privatBankOnline, .privateBankOffline:
            count = CurrencyNetworkService.instance.privatBankCurrency.count
        case .monoBank:
            count = CurrencyNetworkService.instance.monoBankCurrency.count
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CurrencyTableViewCell
        
        switch activeBankType {
        case .privatBankOnline, .privateBankOffline:
            cell.setupCell(currency: CurrencyNetworkService.instance.privatBankCurrency[indexPath.row])
        case .monoBank:
            cell.setupCell(currency: CurrencyNetworkService.instance.monoBankCurrency[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        var currencyName: String = ""
        var currencyBuy: Double = 0
        var currencySale: Double = 0
        var currencySource: String = ""
        
        switch activeBankType {
        case .privatBankOnline, .privateBankOffline:
            let currency = CurrencyNetworkService.instance.privatBankCurrency[indexPath.row]
            
            currencyBuy = Double(currency.buy) ?? 0
            currencySale = Double(currency.sale) ?? 0
            currencyName = currency.ccy

            if activeBankType == .privatBankOnline {
                currencySource = privatSourceName
            } else {
                currencySource = privatOfflineSourceName
            }
            
        case .monoBank:
            let currency = CurrencyNetworkService.instance.monoBankCurrency[indexPath.row]
            
            currencyBuy = currency.rateBuy ?? 0
            currencySale = currency.rateSell ?? 0
            currencySource = monoSouceName
            
            if let name = currencyCode[String(describing: currency.currencyCodeA)] {
                currencyName = name
            }
        }
        
        let currencyFormatBuy = Cell.instance.formatCurrency(number: currencyBuy)
        let currencyFormatSale = Cell.instance.formatCurrency(number: currencySale)
        
        let result = currencySource + ": " + currencyName + " Buy: " + currencyFormatBuy + " Sale: " + currencyFormatSale
        
        let sharedViewController = UIActivityViewController(activityItems: [result], applicationActivities: nil)

        present(sharedViewController, animated: true)
    }
    
    
}

