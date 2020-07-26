//
//  ConverterViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
    
    //MARK: - Properties
    let identifier = "ConverterTableViewCell"
    
    //MARK: - Outlets
    @IBOutlet weak var currenciesListTableView: UITableView!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currenciesListTableView.delegate = self
        self.currenciesListTableView.dataSource = self
        
        self.currenciesListTableView.register(UINib(nibName: "ConverterTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OperationQueue.main.addOperation {
            DatabaseManager.instance.loadLastData {
                self.currenciesListTableView.reloadData()
            }
        }
    }

}

extension ConverterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 80)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.instance.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.currenciesListTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConverterTableViewCell
        
        cell.setupCell(currency: DatabaseManager.instance.currencies[indexPath.row])
        
        return cell
    }
    
    
}
