//
//  BluetoothDualModeViewController.swift
//  ThingIoTAppSDK
//
//  Copyright (c) 2014-2022 Thing Inc. (https://developer.tuya.com/)

import Foundation
import Masonry
import ThingSmartBLEKit
import ThingSmartBLECoreKit
import IndustryActivatorKit
import UIKit

class BluetoothDualModeViewController: UITableViewController {
    let headerView = UIView.init()
    let headerLabel = UILabel.init()
    var deviceInfos = [String: ISmartBLEAdv]()
    var isActiving = false
    var isScan = false
    var ssid: String = "your wifi name"
    var password: String = "your wifi password"
    
    var discovery = DiscoveryService.shared.discovery(.BLEWIFI)
    var pair = ActivatorService.shared.activator(.BLEWIFI)

    init() {
        super.init(style: UITableView.Style.insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopScan()
        self.stopPair()
    }
    
    func setUpUI() {
        self.title = "Bluetooth Dual Mode"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(TYSDKHomeDemoPairBaseCell.self, forCellReuseIdentifier: "pairBaseCell")
        
        self.tableView.tableHeaderView = headerView
        self.headerView.addSubview(self.headerLabel)
        self.headerLabel.frame = CGRect.init(x: 16, y: 0, width: UIScreen.main.bounds.size.width - 32, height: 0)
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 60)
        self.headerLabel.text = "The devices that support Bluetooth and Wi-Fi combo can be paired over either Bluetooth or Wi-Fi."
        self.headerLabel.textColor = UIColor.init(red: 136 / 255.0, green: 136 / 255.0, blue: 136 / 255.0, alpha: 1)
        self.headerLabel.numberOfLines = 0
        self.headerLabel.sizeToFit()
    }
    
    
    func startScan() {
        SVProgressHUD.showSuccess(withStatus: "开始扫描设备")
        self.isScan = true
        self.deviceInfos.removeAll()
        self.tableView.reloadData()
        self.discovery.listener = self
        self.discovery.startDiscovery()
    }
    
    func stopScan() {
        SVProgressHUD.showSuccess(withStatus: "停止扫描设备")
        self.isScan = false
        self.tableView.reloadData()
        self.discovery.stopDiscovery()
    }
    
    
    func startPair(devInfo: ISmartBLEAdv) {
        if self.isActiving {
            SVProgressHUD.showError(withStatus: "正在配网中，请等待配网结束后再进行新的配网")
            return
        }
        
        guard devInfo.uuid != nil else {
            SVProgressHUD.showError(withStatus: "active failed. no uuid")
            return
        }
        
        guard let assetID = UserModel.shared.getGid() else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        guard self.ssid.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "Please input the ssid and password of your Wifi")
            return
        }
        
        
        SVProgressHUD.show()
        self.isActiving = true

        self.pair.listener = self;
        self.pair.startPair(BLEWIFIActivatorParams(deviceInfo: devInfo, assetId: assetID, ssid: self.ssid, password: self.password))
    }
    
    func stopPair() {
        self.isActiving = false
        SVProgressHUD.dismiss()
        self.pair.stopPair()
    }
    
    func inputPassword() {
        let alert = UIAlertController(title: "please input password", message: nil, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = self.password
        }
        
        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction.init(title: "ok", style: .default, handler: { [weak self] _ in
            let textfield = alert.textFields?.first
            self?.password = textfield?.text ?? ""
            self?.tableView.reloadData()
        }))
        
        self.navigationController?.present(alert, animated: true)
    }
    
    func inputSSID() {
        let alert = UIAlertController(title: "please input ssid", message: nil, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = self.ssid
        }
        
        alert.addAction(UIAlertAction.init(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction.init(title: "ok", style: .default, handler: { [weak self] _ in
            let textfield = alert.textFields?.first
            self?.ssid = textfield?.text ?? ""
            self?.tableView.reloadData()
        }))
        
        self.navigationController?.present(alert, animated: true)
    }
}


extension BluetoothDualModeViewController: IDiscoveryListener {
    func didDiscover(device: ISmartBLEAdv?) {
        guard let model = device, let uuid = model.uuid else {return}
        self.deviceInfos[uuid] = model
        self.tableView.reloadData()
    }
}

extension BluetoothDualModeViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        self.isActiving = false
        guard let uuid = deviceModel?.uuid else {
            SVProgressHUD.showSuccess(withStatus: "配网成功")
            return
        }
        
        SVProgressHUD.showSuccess(withStatus: "配网成功: \(uuid)")
        self.deviceInfos.removeValue(forKey: uuid)
        self.tableView.reloadData()
    }
    
    func onError(error: Error) {
        self.isActiving = false
        SVProgressHUD.showError(withStatus: "配网失败")
    }
}


extension BluetoothDualModeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        if section == 1 {
            return 1
        }
        
        if section == 2 {
            return self.deviceInfos.keys.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "wifi info"
        }
        
        if section == 1 {
            return "蓝牙扫描周围设备"
        }
        
        if section == 2 {
            return "扫描到的设备"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "wifiCell")
            }
            cell?.accessoryType = .none
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "ssid"
                cell?.detailTextLabel?.text = self.ssid
            }else{
                cell?.textLabel?.text = "password"
                cell?.detailTextLabel?.text = self.password
            }
            return cell!
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
            if self.isScan {
                cell?.textLabel?.text = "停止扫描"
            }else{
                cell?.textLabel?.text = "开始扫描"
            }
            
            return cell!
        }
        
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pairBaseCell") as? TYSDKHomeDemoPairBaseCell else {
                return UITableViewCell.init()
            }
            
            let keys = self.deviceInfos.keys.sorted()
            let uuid = keys[indexPath.row]
            let devInfo = self.deviceInfos[uuid]
            cell.set(title: uuid, subTitle: devInfo!.productId ?? "")
            cell.pairHandler = { [weak self] () in
                self?.startPair(devInfo: devInfo!)
            }
            
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.inputSSID()
            }else{
                self.inputPassword()
            }
        }
        
        if indexPath.section == 1 {
            if self.isScan {
                self.stopScan()
            }else{
                self.startScan()
            }
        }
    }
}
