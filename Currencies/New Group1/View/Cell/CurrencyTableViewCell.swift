//
//  CurrencyTableViewCell.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyBuyLabel: UILabel!
    @IBOutlet weak var currencySaleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Cell.instance.setBorderImage(self.currencyImage)
    }
    
    func setupCell(currency: CurrencyModel) {
        
        if  let image = Cell.instance.getCellImage(currencyName: currency.ccy) {
        
            self.currencyBuyLabel.text = Cell.instance.formatCurrency(number: currency.buy)
            self.currencySaleLabel.text = Cell.instance.formatCurrency(number: currency.sell)
            self.currencyImage.image = image
        }
    }
    
}
