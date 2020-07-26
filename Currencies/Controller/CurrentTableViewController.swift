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
        
        self.showIndicator()
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType, completion: {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.showSuccessIndicator()
            }
        }, showError: {
            self.showErrorIndicator()
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showIndicator()
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType, completion: {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.showSuccessIndicator()
            }
            
            DispatchQueue.main.async {
                DatabaseManager.instance.loadData {
                    if DatabaseManager.instance.currencies.count == 0 {
                        DatabaseManager.instance.saveData(type: activeBankType, complete: nil)
                    }
                }
                
                DatabaseManager.instance.loadLastData {
                    
                    let currentCurrencies = CurrencyNetworkService.instance.currentCurrency
                    
                    let lastCurrencies = DatabaseManager.instance.currencies[0...currentCurrencies.count-1]
                    
                    for index in 0...currentCurrencies.count-1 {
                        
                        guard let lastBuy = lastCurrencies[index].buy else { return }
                        guard let lastSale = lastCurrencies[index].sale else { return }
                        
                        let currentBuy = currentCurrencies[index].buy
                        let currentSale = currentCurrencies[index].sell
                        let lastBuyDouble = (lastBuy as NSString).doubleValue
                        let lastSaleDouble = (lastSale as NSString).doubleValue
                        
                        if currentBuy != lastBuyDouble {
                            print("\(currentBuy) != \(lastBuyDouble)")
                        }
                        
                        if currentSale != lastSaleDouble {
                            print("\(currentSale) != \(lastSaleDouble)")
                        }
                    }
                    
                }
            }
            
        }, showError: {
            self.showErrorIndicator()
        })
        
    }
    
    func compareCurrency () -> Bool {
        return true
    }
    
    func showIndicator() {
        self.hud.textLabel.text = "Loading"
        self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        self.hud.show(in: self.view)
    }
    
    func showSuccessIndicator() {
        self.hud.textLabel.text = "Success"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.dismiss(afterDelay: 0.5, animated: true)
    }
    
    func showErrorIndicator() {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Error"
            UIView.animate(withDuration: 0.5) {
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            }
            self.hud.dismiss(afterDelay: 1.0, animated: true)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
        
        CurrencyNetworkService.instance.loadCurrency(bankType: activeBankType, completion: {
            OperationQueue.main.addOperation {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                //                DatabaseManager.instance.saveData(type: activeBankType, complete: nil)
            }
        }, showError: {
            self.showErrorIndicator()
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        })
        
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
        
        if CurrencyNetworkService.instance.currentCurrency.count > 0 {
            
            let currency = CurrencyNetworkService.instance.currentCurrency[indexPath.row]
            
            let currencyName: String = currency.ccy
            let currencyBuy: Double = currency.buy
            let currencySale: Double = currency.sell
            var currencySource: String = ""
            
            switch activeBankType {
            case .privatBankOnline:
                currencySource = privatSourceName
            case .privateBankOffline:
                currencySource = privatOfflineSourceName
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
}

