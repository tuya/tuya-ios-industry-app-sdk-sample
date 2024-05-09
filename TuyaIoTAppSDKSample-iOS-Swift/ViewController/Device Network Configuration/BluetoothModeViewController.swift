//
//  BluetoothModeViewController.swift
//  ThingIoTAppSDK
//
//  Copyright (c) 2014-2022 Thing Inc. (https://developer.tuya.com/)

import Foundation
import Masonry
import ThingSmartBLEKit
import ThingSmartBLECoreKit
import IndustryActivatorKit
import IndustryActivatorImpl

class BluetoothModeViewController: UITableViewController {
    let headerView = UIView.init()
    let headerLabel = UILabel.init()
    var deviceInfos = [String: ISmartBLEAdv]()
    var isActiving = false
    var isScan = false
    
    var discovery = DiscoveryService.shared.discovery(.BLE)
    var pair = ActivatorService.shared.activator(.BLE)
    
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
        self.title = "Bluetooth Mode"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(TYSDKHomeDemoPairBaseCell.self, forCellReuseIdentifier: "pairBaseCell")
        
        self.tableView.tableHeaderView = headerView
        self.headerView.addSubview(self.headerLabel)
        self.headerLabel.frame = CGRect.init(x: 16, y: 0, width: UIScreen.main.bounds.size.width - 32, height: 0)
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 60)
        self.headerLabel.text = "A peer-to-peer connection is created between a Bluetooth or Bluetooth LE device and a mobile phone."
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
        
        if devInfo.uuid == nil {
            SVProgressHUD.showError(withStatus: "active failed. no uuid")
            return
        }
        
        guard let assetID = UserModel.shared.getGid() else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        SVProgressHUD.show()
        self.isActiving = true

        self.pair.listener = self;
        self.pair.startPair(BLEActivatorParams(deviceInfo: devInfo, assetId: assetID))
    }
    
    func stopPair() {
        self.isActiving = false
        SVProgressHUD.dismiss()
        self.pair.stopPair()
    }
}

extension BluetoothModeViewController: IDiscoveryListener {
    func didDiscover(device: ISmartBLEAdv?) {
        guard let model = device, let uuid = model.uuid else {return}
        self.deviceInfos[uuid] = model
        self.tableView.reloadData()
    }
}

extension BluetoothModeViewController: IActivatorListener {
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

extension BluetoothModeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return self.deviceInfos.keys.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "蓝牙扫描周围设备"
        }
        
        if section == 1 {
            return "扫描到的设备"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
            if self.isScan {
                cell?.textLabel?.text = "停止扫描"
            }else{
                cell?.textLabel?.text = "开始扫描"
            }
            
            return cell!
        }
        
        if indexPath.section == 1 {
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
            if self.isScan {
                self.stopScan()
            }else{
                self.startScan()
            }
        }
    }
}



class TYSDKHomeDemoPairBaseCell: UITableViewCell {
    var pairHandler: ThingSuccessHandler?
    let pairBtn: UIButton
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.pairBtn = UIButton.init(type: .custom)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, subTitle: String) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = title
    }
    
    func setUpUI() {
        self.pairBtn.setTitle("配网", for: .normal)
        self.pairBtn.setTitleColor(.white, for: .normal)
        self.pairBtn.backgroundColor = .orange.withAlphaComponent(0.9)
        self.pairBtn.layer.cornerRadius = 6
        self.pairBtn.layer.masksToBounds = true
        self.pairBtn.addTarget(self, action: #selector(clickPairBtn), for: .touchUpInside)
        
        self.contentView.addSubview(self.pairBtn)
        self.pairBtn.mas_makeConstraints { maker in
            maker?.top.mas_equalTo()(8)
            maker?.bottom.mas_equalTo()(-8)
            maker?.right.equalTo()(self.contentView)?.offset()(-10)
            maker?.width.mas_equalTo()(70)
        }
    }
    
    @objc func clickPairBtn() {
        self.pairHandler?()
    }
}
