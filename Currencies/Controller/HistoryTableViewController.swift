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
        
        DatabaseManager.instance.loadData {
            self.tableView.reloadData()
        }
    }
    
}

extension HistoryTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.instance.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HistoryTableViewCell
        
        let currency = DatabaseManager.instance.currencies[indexPath.row]
        
        cell.setupCell(currency: currency, bankType: activeBankType)
        cell.selectionStyle = .none
        
        return cell
    }
    
}
