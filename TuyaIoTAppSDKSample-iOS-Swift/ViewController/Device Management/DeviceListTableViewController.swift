//
//  DeviceListTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class DeviceListTableViewController: UITableViewController {
    // MARK: - Property
    var deviceList = [TYDevice]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        requestDeviceList()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "device-list-cell")!
        let model = deviceList[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.isOnline == true ? "online" : "offline"
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device = deviceList[indexPath.row]
        if device.isOnline {
            let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeviceControlTableViewController") as! DeviceControlTableViewController
            vc.device = device
            navigationController?.pushViewController(vc, animated: true)
        } else {
            SVProgressHUD.showInfo(withStatus: "Device Offline")
        }
    }

    // MARK: - Private method
    private func requestDeviceList() {
        guard let assetID = UserModel.shared.asset?.id else {
            SVProgressHUD.showError(withStatus: "Please select an asset.")
            navigationController?.popViewController(animated: true)
            return
        }
        
        SVProgressHUD.show()
        TYDeviceManager().queryDeviceIDList(under: assetID) { (result, error) in
            
            if error == nil && result?.devices.count == 0 {
                SVProgressHUD.showInfo(withStatus: "No device.")
                return
            }
            
            let array = result?.devices
            if (array != nil) {
                var idArray = [String]()
                array?.forEach({ (device) in
                    idArray.append(device.id)
                })

                TYDeviceManager().queryDevicesInfo(of: idArray) { [weak self] (deviceArray, error) in
                    if (deviceArray != nil) {
                        guard let self = self else { return }
                        self.deviceList = deviceArray!
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    } else {
                        SVProgressHUD.showInfo(withStatus: "Failed to fetch devices.")
                    }
                }
            } else {
                SVProgressHUD.showInfo(withStatus: "Failed the fetch devices' ID.")
            }
        }
    }
}
