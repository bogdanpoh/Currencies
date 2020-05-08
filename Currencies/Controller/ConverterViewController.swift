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
    
    //MARK: - Outlets
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var equalityButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var firstSelectCurrencyButton: UIButton!
    @IBOutlet weak var secondSelectCurrencyButton: UIButton!
    
    
    //MARK: - Properties
    var selectLabel: UILabel!
    
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLabel = firstLabel
        
        let deleteButtonLongTapped = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        self.deleteButton.addGestureRecognizer(deleteButtonLongTapped)
    }
    
    func changeStateButton(_ button: UIButton, _ state: ButtonState) {
        
        var downColor: UIColor!
        
        switch button {
        case changeButton:
            downColor = .systemYellow
            
        case addButton:
            downColor = .systemGreen
            
        case subButton:
            downColor = .systemRed
            
        case equalityButton:
            downColor = .systemBlue
            
        default:
            downColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
        
        setButtonImage(button, state)
        
        changeBackgroundColorButton(button, state, downTappedColor: downColor)
        
    }
    
    func setButtonImage(_ button: UIButton, _ state: ButtonState) {
        
        var imageName: String?
        let buttonControlState: UIControl.State = getCurrentControlState(state)
        
        switch state {
        case .upTapped:
            switch button {
            case deleteButton:
                imageName = "delete-outline"
            case changeButton:
                imageName = "change"
            case addButton:
                imageName = "add"
            case subButton:
                imageName = "sub"
            case equalityButton:
                imageName = "equality"
            default:
                break
            }
        case .downTapped:
            switch button {
            case deleteButton:
                imageName = "delete-fill"
            case changeButton:
                imageName = "change-select"
            case addButton:
                imageName = "add-select"
            case subButton:
                imageName = "sub-select"
            case equalityButton:
                imageName = "equality-select"
            default:
                break
            }
        }
        
        if let name = imageName {
            if let image = UIImage(named: name) {
                button.setImage(image, for: buttonControlState)
            }
        }
    }
    
    func getCurrentControlState(_ state: ButtonState) -> UIControl.State {
        switch state {
        case .upTapped:
            return .normal
        case .downTapped:
            return .highlighted
        }
    }
    
    func changeBackgroundColorButton(_ button: UIButton, _ state: ButtonState, upTappedColor: UIColor = .white, downTappedColor: UIColor) {
        switch state {
        case .upTapped:
            button.backgroundColor = upTappedColor
        case .downTapped:
            button.backgroundColor = downTappedColor
        }
    }
    
    func changeLabel(currentLabel: UILabel) {
        
        if currentLabel == firstLabel {
            selectLabel = secondLabel
        } else if currentLabel == secondLabel {
            selectLabel = firstLabel
        }
        
    }
    
    func inputNumberToLabel(_ text: String) {
        if var selectLabelText = selectLabel.text {
            
            if selectLabelText.first == "0" {
                selectLabelText.removeFirst()
            }
            
            guard let symbol = selectLabelText.last else { return }
            
            selectLabelText.removeLast()
            
            selectLabel.text = "\(selectLabelText)\(text)\(symbol)"
        }
    }
    
    func removeLastInLabel() {
        if var selectLabelText = selectLabel.text {
        
            guard let symbol = selectLabel.text?.last else { return }
            let result = selectLabelText.replacingOccurrences(of: String(describing: symbol), with: "")
            selectLabelText = result
            selectLabelText.removeLast()
            
            if selectLabelText.count >= 1 {
                selectLabel.text = "\(selectLabelText)\(symbol)"
            } else {
                selectLabel.text = "0\(symbol)"
            }
            
        }
    }
    
    //MARK: - Actions
    @IBAction func downButtonTapped(_ sender: UIButton) {
        changeStateButton(sender, .downTapped)
    }
    
    
    @IBAction func upInsideButtonTapped(_ sender: UIButton) {
        changeStateButton(sender, .upTapped)
        
        if let value = sender.titleLabel?.text {
            inputNumberToLabel(value)
        } else {
            switch sender {
            case deleteButton:
                removeLastInLabel()
            default:
                break
            }
        }
    }
    
    @objc func longTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            print("Long pressed")
            deleteButton.backgroundColor = .white
        }
    }
}
