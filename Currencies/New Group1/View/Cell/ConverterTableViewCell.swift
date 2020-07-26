//
//  ConverterTableViewCell.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 11.06.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class ConverterTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var converterImageView: UIImageView!
    
    @IBOutlet weak var converterSymbolLabel: UILabel!
    
    @IBOutlet weak var converterValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(currency: Currency) {
        
        guard let currencyName = currency.name else { return }
        
        if let image = Cell.instance.getCellImage(currencyName: currencyName) {
            self.converterImageView.image = image
            self.converterSymbolLabel.text = "Symbol"
            self.converterValueLabel.text = currency.buy
        }
    }
    
}
