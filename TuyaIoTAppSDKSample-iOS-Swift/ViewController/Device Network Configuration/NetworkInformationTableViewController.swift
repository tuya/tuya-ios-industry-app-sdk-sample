//
//  NetworkInformationTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class NetworkInformationTableViewController: UITableViewController {
    public var pairingType: NetworkPairingType = .EZ
    
    public enum NetworkPairingType: Int {
        case EZ
        case AP
        case QRCode
    }
    
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ssidTextField.text = "your wifi name"
        self.passwordTextField.text = "your wifi password"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (ssidTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "Please enter Wi-Fi SSID and password.")
            return
        }
        
        var identifier: String = ""
        switch pairingType {
        case .EZ:
            identifier = "EZMode"
            break
        case .AP:
            identifier = "APMode"
            break
        case .QRCode:
            identifier = "QRCodeMode"
        }
                
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EZMode":
            let vc = segue.destination as! WiFiModeTableViewController
            vc.ssid = ssidTextField.text!
            vc.password = passwordTextField.text!
            vc.wifiType = .EZ
            break
        case "APMode":
            let vc = segue.destination as! WiFiModeTableViewController
            vc.ssid = ssidTextField.text!
            vc.password = passwordTextField.text!
            vc.wifiType = .AP
            break
        case "QRCodeMode":
            let vc = segue.destination as! QRCodePairViewController
            vc.ssid = ssidTextField.text!
            vc.password = passwordTextField.text!
        default:
            break
        }
    }

}
