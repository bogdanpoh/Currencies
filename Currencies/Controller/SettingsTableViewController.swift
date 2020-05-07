//
//  SettingsTableViewController.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 06.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//

import UIKit

let keys = [privatOnlineKey, privatOfflineKey, monobankKey]

var activeBankType: BankType {
    
    var result: BankType = .privatBankOnline
    
    keys.forEach { (key) in
        if UserDefaults.standard.bool(forKey: key) {
            switch key {
            case privatOnlineKey:
                result = .privatBankOnline
            case privatOfflineKey:
                result = .privateBankOffline
            case monobankKey:
                result = .monoBank
            default:
                result = .privatBankOnline
            }
        }
    }
    
    return result
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var privatBankOnlineSwitch: UISwitch!
    @IBOutlet weak var privatBankOfflineSwitch: UISwitch!
    @IBOutlet weak var monobankSwitch: UISwitch!
    
    @IBOutlet weak var privatBankOnlineCell: UITableViewCell!
    @IBOutlet weak var privatBankOfflineCell: UITableViewCell!
    @IBOutlet weak var monobankCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privatBankOnlineCell.selectionStyle = .none
        privatBankOfflineCell.selectionStyle = .none
        monobankCell.selectionStyle = .none
        
        loadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
    }
    
    func loadSettings() {
        privatBankOnlineSwitch.isOn = UserDefaults.standard.bool(forKey: privatOnlineKey)
        privatBankOfflineSwitch.isOn = UserDefaults.standard.bool(forKey: privatOfflineKey)
        monobankSwitch.isOn = UserDefaults.standard.bool(forKey: monobankKey)
        
        if !privatBankOnlineSwitch.isOn && !privatBankOfflineSwitch.isOn && !monobankSwitch.isOn {
            privatBankOnlineSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: privatOnlineKey)
        }
        
    }
    
    @IBAction func clearDBPressedAction(_ sender: UIButton) {
        DatabaseManager.instance.removeAllData()
    }
    
    
    @IBAction func privatBankOnlineAction(_ sender: UISwitch) {
        changeValue(sender: sender, switches: [privatBankOfflineSwitch, monobankSwitch], saveKey: privatOnlineKey)
    }
    
    @IBAction func privatBankOfflineAction(_ sender: UISwitch) {
        changeValue(sender: sender, switches: [privatBankOnlineSwitch, monobankSwitch], saveKey: privatOfflineKey)
    }
    
    @IBAction func monobankAction(_ sender: UISwitch) {
        changeValue(sender: sender, switches: [privatBankOnlineSwitch, privatBankOfflineSwitch], saveKey: monobankKey)
    }
    
    func changeValue(sender: UISwitch, switches: [UISwitch], saveKey: String) {
        
        if sender.isOn {
            switches.forEach { (switcher) in
                switcher.isOn = false
            }
            keys.forEach { (key) in
                if key != saveKey {
                    UserDefaults.standard.set(false, forKey: key)
                } else {
                    UserDefaults.standard.set(true, forKey: key)
                }
            }
        }
    }
    
}

