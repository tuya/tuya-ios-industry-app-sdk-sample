//
//  DeviceDetailTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class DeviceDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var removeDeviceButton: UIButton!
    var newName: String = ""
    
    // MARK: - Property
    var device: TYDevice?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceIDLabel.text = device?.id
        ipAddressLabel.text = device?.ipAddress
        productName.text = device?.name
    }

    // MARK: - IBAction
    @IBAction func removeDeviceTapped(_ sender: UIButton) {
        let removeAction = UIAlertAction(title: NSLocalizedString("Remove", comment: "Perform remove device action"), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            TYDeviceManager().removeDevice(self.device!.id) { (bool, error) in
                if bool == true {
                    SVProgressHUD.showInfo(withStatus: "Remove success")
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
                SVProgressHUD.showError(withStatus: "Remove failed")
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        let alert = UIAlertController(title: NSLocalizedString("Remove the Device?", comment: ""), message: NSLocalizedString("If you choose to remove the device, you'll no long hold control over this device.", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = sender
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateDeviceName() {
        let alertVC = UIAlertController.init(title: "New device name", message: "", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
        }
        let confirmAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            
            if self.newName.count == 0 { return }
            TYDeviceManager().modifyDeviceName(for: self.device!.id, to: self.newName) { (bool, error) in
                if bool == true {
                    SVProgressHUD.showInfo(withStatus: "Success")
                } else {
                    SVProgressHUD.showError(withStatus: "Fail")
                }
            }

        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        newName = textField.text!
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 2 {
            updateDeviceName()
        }
        
        guard indexPath.section == 1 else { return }
        removeDeviceButton.sendActions(for: .touchUpInside)
        
        
    }
    
}
