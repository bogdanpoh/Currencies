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
    
    func setupCell(currency: PrivatbankCurrencyModel) {
        
        guard let doubleBuy = Double(currency.buy) else { return }
        guard let doubleSale = Double(currency.sale) else { return }
        guard let image = Cell.instance.getCellImage(currencyName: currency.ccy, currencyType: .privatBankOnline) else { return }
        
//        let doubleBuy = 22.2
//        let doubleSale = 22.3
//        let image = UIImage(named: "urk-flag")!
        
        setup(buy: Cell.instance.formatCurrency(number: doubleBuy),
              sale: Cell.instance.formatCurrency(number: doubleSale),
              image: image)
        
    }
    
    func setupCell(currency: MonobankCurrencyModel) {
        
        guard let doubleBuy = currency.rateBuy else { return }
        guard let doubleSale = currency.rateSell else { return }
        guard let image = Cell.instance.getCellImage(currencyName: "\(currency.currencyCodeA)", currencyType: .monoBank) else { return }
        
        setup(buy: Cell.instance.formatCurrency(number: doubleBuy),
              sale: Cell.instance.formatCurrency(number: doubleSale),
              image: image)
    }
    
    private func setup(buy: String, sale: String, image: UIImage) {
        self.currencyBuyLabel.text = buy
        self.currencySaleLabel.text = sale
        self.currencyImage.image = image
    }
    
}
