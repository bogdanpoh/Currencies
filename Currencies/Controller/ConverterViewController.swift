//
//  ConverterViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

enum ButtonState {
    case upTapped, downTapped
}

class ConverterViewController: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        changeStateButton(sender, .downTapped)
    }
    
    
    @IBAction func upInsideButtonTapped(_ sender: UIButton) {
        changeStateButton(sender, .upTapped)
    }
    
    func changeStateButton(_ button: UIButton, _ state: ButtonState) {
        
        var buttonImageName = ""
        let buttonControlState: UIControl.State = getCurrentControlState(state)
        
        switch button {
        case deleteButton:
            buttonImageName = "delete"
        default:
            break
        }
        
        if let name = getButtonImage(buttonImageName, state) {
            button.setImage(name, for: buttonControlState)
        }
        
        switch state {
        case .upTapped:
            button.backgroundColor = .white
        case .downTapped:
            button.backgroundColor = .lightGray
        }
    }
    
    func getButtonImage(_ nameImage: String, _ state: ButtonState) -> UIImage? {
        
        var name = ""
        
        switch state {
        case .upTapped:
            name = nameImage + "-outline"
        case .downTapped:
            name = nameImage + "-fill"
        }
        
        return UIImage(named: name, in: nil, with: nil)
    }
    
    func getCurrentControlState(_ state: ButtonState) -> UIControl.State {
        switch state {
        case .upTapped:
            return .normal
        case .downTapped:
            return .highlighted
        }
    }
}
