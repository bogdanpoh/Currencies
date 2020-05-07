//
//  ConverterViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .lightGray
    }
    
    
    @IBAction func upInsideButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .white
    }
    

}
