//
//  NetworkInformationTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class NetworkInformationTableViewController: UITableViewController {
    public var pairingType: NetworkPairingType = .AP
    
    public enum NetworkPairingType: Int {
        case AP
        case QR
    }
    
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (ssidTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "Please enter Wi-Fi SSID and password.")
            return
        }
        
        var identifier: String = ""
        switch pairingType {
        case .AP:
            identifier = "APMode"
            break
        case .QR:
            identifier = "QRMode"
            break
        default:
            identifier = "APMode"
            break
        }
                
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "APMode":
            let vc = segue.destination as! APModeTableViewController
            vc.ssid = ssidTextField.text!
            vc.password = passwordTextField.text!
            break
        case "QRMode":
            let vc = segue.destination as! QRModelViewController
            vc.ssid = ssidTextField.text!
            vc.password = passwordTextField.text!
            break
            
        default:
            break
        }
    }

}
