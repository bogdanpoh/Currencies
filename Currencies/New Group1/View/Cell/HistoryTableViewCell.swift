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
    
    func setupCell(currency: Currency, bankType: BankType) {

        guard let name = currency.name else { return }
        guard let buy = currency.buy else { return }
        guard let sale = currency.sale else { return }
        guard let date = currency.date else { return }
        guard let image = Cell.instance.getCellImage(currencyName: name, currencyType: bankType) else { return }

        guard let doubleBuy = Double(buy) else { return }
        guard let doubleSale = Double(sale) else { return }

        setup(name,
              Cell.instance.formatCurrency(number: doubleBuy),
              Cell.instance.formatCurrency(number: doubleSale),
              date,
              image)
    }
    
    private func setup(_ name: String, _ buy: String, _ sale: String,_ date: String, _ image: UIImage) {
        
        self.historyNameLabel.text = name
        self.historyBuyLabel.text = buy
        self.historySaleLabel.text = sale
        self.historyDateLabel.text = date
        self.historyImageView.image = image
    }
    
}
