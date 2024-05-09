//
//  SubDeviceViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2022 Tuya Inc. (https://developer.tuya.com/)

import Foundation
import IndustryDeviceKit
import IndustryActivatorKit

class SubDeviceViewController: UITableViewController {
    var gateway: IDevice?
    var subDevices = [IDevice]()
    var pair: IActivator = ActivatorService.shared.activator(.zigbeeSubDevice)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutView()
        self.getSubDevices()
    }
    
    @objc func getSubDevices() {
        guard let gw = gateway else {
            return
        }
        
        SVProgressHUD.show()
        gw.subDevices { devices in
            SVProgressHUD.dismiss()
            self.subDevices.removeAll()
            self.subDevices.append(contentsOf: devices)
            self.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func layoutView() {
        self.title = "SubDevice list"
        
        let barButtonItem = UIBarButtonItem.init(title: "subDevicePair", style: .plain, target: self, action: #selector(startPair))
        barButtonItem.tintColor = UIColor.blue
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func startPair() {
        
        guard let deviceId = gateway?.deviceId, let localKey = gateway?.localKey, let pv = gateway?.pv else {
            return
        }
        
        SVProgressHUD.show()
        self.pair.listener = self
        self.pair.startPair(ZigbeeSubDeviceActivatorParams(gwId: deviceId, localKey: localKey, pv: pv))
    }
    
    
    @objc func stopPair() {
        SVProgressHUD.dismiss()
        self.pair.stopPair()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopPair()
    }
}

extension SubDeviceViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "device-list-cell")!
        let model = subDevices[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.isOnline == true ? "online" : "offline"
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let deviceId = subDevices[indexPath.row].deviceId else {
            return
        }
        
        SVProgressHUD.show()
        DeviceService.shared.load(deviceId) { [weak self] device in
            SVProgressHUD.dismiss()
            
            let storyboard = UIStoryboard(name: "DeviceList", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeviceControlTableViewController") as! DeviceControlTableViewController
            vc.device = device
            self?.navigationController?.pushViewController(vc, animated: true)

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
            guard let deviceId = self.subDevices[indexPath.row].deviceId else {return}

            SVProgressHUD.show()
            DeviceService.shared.remove(deviceId) {
                SVProgressHUD.dismiss()
                self.getSubDevices()
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
}

extension SubDeviceViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        SVProgressHUD.dismiss()
        self.getSubDevices()
    }
    
    func onError(error: Error) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: error.localizedDescription)
    }
}
