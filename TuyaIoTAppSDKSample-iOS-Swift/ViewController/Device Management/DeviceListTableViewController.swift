//
//  DeviceListTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryAssetKit
import IndustryDeviceKit
import IndustryDeviceImpl
import IndustryActivatorKit

import TuyaSmartBLEKit

class DeviceListTableViewController: UITableViewController {
    // MARK: - Property
    var deviceList = [IAssetDevice]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        requestDeviceList()
    
//        let discovery: IDiscovery = DiscoveryService.shared.discovery(.BLE)
//        discovery.startDiscovery()
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
        cell.textLabel?.text = model.deviceName
        
        let device: IDevice = IndustryDevice(deviceId: model.deviceId)
        cell.detailTextLabel?.text = device.isOnline == true ? "online" : "offline"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        SVProgressHUD.show()
        DeviceService.shared.load(deviceList[indexPath.row].deviceId) {[weak self] device in
            SVProgressHUD.dismiss()
            if device.deviceType == .wifiGatewayDevice || device.deviceType == .zigbeeGatewayDevice || device.deviceType == .infraredGatewayDevice || device.deviceType == .sigMeshGatewayDevice {
                let storyboard = UIStoryboard(name: "SubDeviceList", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SubDeviceViewController") as! SubDeviceViewController
                vc.gateway = device
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DeviceControlTableViewController") as! DeviceControlTableViewController
                vc.device = device
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        let removeAction = UIAlertAction(title: NSLocalizedString("Remove", comment: "Perform remove device action"), style: .destructive) { [weak self] (action) in
            guard let self = self else { return }
            let deviceId = self.deviceList[indexPath.row].deviceId
            
            SVProgressHUD.show()
            DeviceService.shared.remove(deviceId) {
                SVProgressHUD.dismiss()
                self.deviceList.removeAll()
                self.requestDeviceList()
            } failure: { error in
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Remove failed")
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        let alert = UIAlertController(title: NSLocalizedString("Remove the Device?", comment: ""), message: NSLocalizedString("If you choose to remove the device, you'll no long hold control over this device.", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
                
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Private method
    static var lastRowKey:String? = nil
    private func requestDeviceList() {
        guard let assetID = UserModel.shared.asset?.assetId else {
            SVProgressHUD.showError(withStatus: "Please select an asset.")
            navigationController?.popViewController(animated: true)
            return
        }
        
        SVProgressHUD.show()
        AssetService.shared.devices(assetId: assetID, lastRowKey: DeviceListTableViewController.lastRowKey) { [weak self] assetdDeviceList in
            guard let self = self else { return }
            if assetdDeviceList.devices.count > 0 {
                self.deviceList.append(contentsOf: assetdDeviceList.devices)
                DeviceListTableViewController.lastRowKey = assetdDeviceList.lastRowKey
                self.requestDeviceList()
                self.tableView.reloadData()
            } else {
                DeviceListTableViewController.lastRowKey = nil
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
            
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: "Failed to fetch devices.")
        }
    }
}
