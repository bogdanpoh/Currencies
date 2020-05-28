//
//  HistoryTableViewCell.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyImageView: UIImageView!
    @IBOutlet weak var historyNameLabel: UILabel!
    @IBOutlet weak var historyBuyLabel: UILabel!
    @IBOutlet weak var historySaleLabel: UILabel!
    @IBOutlet weak var historyDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Cell.instance.setBorderImage(self.historyImageView)
    }
    
    func setupCell(currency: Currency) {
        
        guard let name = currency.name else { return }
        guard let buy = currency.buy else { return }
        guard let sale = currency.sale else { return }
        guard let date = currency.date else { return }
        guard let image = Cell.instance.getCellImage(currencyName: name) else { return }
        
        guard let doubleBuy = Double(buy) else { return }
        guard let doubleSale = Double(sale) else { return }
        
        self.historyNameLabel.text = name
        self.historyBuyLabel.text = Cell.instance.formatCurrency(number: doubleBuy)
        self.historySaleLabel.text = Cell.instance.formatCurrency(number: doubleSale)
        self.historyDateLabel.text = date
        self.historyImageView.image = image
    }
    
}
