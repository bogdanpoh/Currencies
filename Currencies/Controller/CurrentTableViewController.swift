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
    
    // MARK: - Properties
    let identifier = "CurrencyTableViewCell"
    
    let hud = JGProgressHUD(style: .dark)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    
        hud.show(in: self.view)
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType){
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.hud.dismiss(animated: true)
//                DatabaseManager.instance.saveData(type: activeBankType, complete: nil)
                
                DatabaseManager.instance.loadData {
//                    print(CurrencyNetworkService.instance.privatBankCurrency)
//                    print()
//                    print(DatabaseManager.instance.currentDateCurrencies)
                }
                
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
    
    func checkCurrencies() -> Bool {
        
        
        
        return false
    }
    
    //MARK: - Actions
    
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
    
    //MARK: - Extensions
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyNetworkService.instance.currentCurrency.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CurrencyTableViewCell
        
        cell.setupCell(currency: CurrencyNetworkService.instance.currentCurrency[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let currency = CurrencyNetworkService.instance.currentCurrency[indexPath.row]
        
        let currencyName: String = currency.ccy
        let currencyBuy: Double = currency.buy
        let currencySale: Double = currency.sell
        var currencySource: String = ""
        
        switch activeBankType {
        case .privatBankOnline, .privateBankOffline:
            currencySource = privatSourceName

        case .monoBank:
            currencySource = monoSouceName
        }
        
        let currencyFormatBuy = Cell.instance.formatCurrency(number: currencyBuy)
        let currencyFormatSale = Cell.instance.formatCurrency(number: currencySale)
        
        let result = currencySource + ": " + currencyName + " Buy: " + currencyFormatBuy + " Sale: " + currencyFormatSale
        
        let sharedViewController = UIActivityViewController(activityItems: [result], applicationActivities: nil)

        present(sharedViewController, animated: true)
    }
    

    
}

