//
//  DeviceDetailTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryDeviceKit
import IndustryActivatorKit
import IndustryDeviceImpl

class DeviceDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var removeDeviceButton: UIButton!
    @IBOutlet weak var blewifiCloud: UILabel!
    var newName: String = ""
    var wifiEnable: Bool = false
    var pair = ActivatorService.shared.activator(.BLEWIFICloud)
    
    // MARK: - Property
    var device: IDevice?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceIDLabel.text = device?.deviceId
        productName.text = device?.name
        device?.delegate = self
        
        var meta = device?.meta
        if let wifiEnable = meta?["wifiEnable"], wifiEnable as! Bool == false {
            print("WiFi is disabled.")
            self.blewifiCloud.text = "false"
            self.wifiEnable = false
        } else {
            self.blewifiCloud.text = "true"
            self.wifiEnable = true
            print("WiFi is enabled.")
        }
    }

    // MARK: - IBAction
    @IBAction func removeDeviceTapped(_ sender: UIButton) {
        let removeAction = UIAlertAction(title: NSLocalizedString("Remove", comment: "Perform remove device action"), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            guard let device = self.device, let deviceId = device.deviceId else {
                return
            }
            DeviceService.shared.remove(deviceId) {
                SVProgressHUD.showInfo(withStatus: "Remove success")
                self.navigationController?.popToRootViewController(animated: true)
            } failure: { error in
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
            guard let device = self.device, let deviceId = device.deviceId else {
                return
            }

            DeviceService.shared.rename(deviceId, newName: self.newName) {
                SVProgressHUD.showInfo(withStatus: "Success")
            } failure: { error in
                SVProgressHUD.showError(withStatus: "Fail")
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
        else if indexPath.section == 0 && indexPath.row == 3 {
            let iDevice = IndustryDevice(deviceId: device?.deviceId ?? "")
            iDevice.connectBLE {
                self.pair.startPair(BLEWIFICloudActivatorParams(devId: (self.device?.deviceId)!, ssid: "", password: ""))
            } failure: {
                
            }
        }
        
        guard indexPath.section == 1 else { return }
        removeDeviceButton.sendActions(for: .touchUpInside)
    }
}


extension DeviceDetailTableViewController: IDeviceDelegate {
    
    func deviceInfoUpdated(device: IDevice) {
        productName.text = device.name
    }
    
}
