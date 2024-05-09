//
//  WiFiModeTableViewController.swift
//  ThingAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Thing Inc. (https://developer.tuya.com/)

import UIKit
import IndustryActivatorKit
import ThingSmartPairingCoreKit

enum WiFiType:Int {
    case EZ
    case AP
}

class WiFiModeTableViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var wifiTitle: UILabel!
    @IBOutlet weak var tokenBtn: UIButton!
    
    var wifiType:WiFiType = .EZ
    var ssid: String = ""
    var password: String = ""
    var pairingToken: String = ""
    var pair: IActivator!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.wifiType {
            case .EZ:
                self.title = "EZ"
                self.wifiTitle.text = "This topic describes the Wi-Fi Easy Connect (EZ) or SmartConfig mode to pair devices. After a user connects a mobile phone to a router, the router broadcasting is used to communicate and pair with a target device. It is easy-to-use, but has compatibility requirements for mobile phones and routers. The success rate is lower than that of the hotspot or access point (AP) mode."
                self.pair = ActivatorService.shared.activator(.EZ)
            case .AP:
                self.title = "AP"
                self.pair = ActivatorService.shared.activator(.AP)
        }
        
        self.updateBtnToken()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
    }
    
    @IBAction func requestToken(_ sender: Any) {
        guard let assetID = UserModel.shared.getGid() else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        SVProgressHUD.show()
        ActivatorService.shared.activatorToken(assetId: assetID, longitude: nil, latitude: nil) { [weak self] token in
            guard let self = self else { return }
            self.pairingToken = token
            self.updateBtnToken()
            SVProgressHUD.dismiss()
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func updateBtnToken() {
        if self.pairingToken.count == 0 {
            self.tokenBtn.setTitle("Get token first", for: .normal)
        }else{
            self.tokenBtn.setTitle("token: \(self.pairingToken)", for: .normal)
        }
    }
    
    // MARK: - IBAction
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        self.start()
    }
    
    private func start() {
        pair.listener = self

        switch self.wifiType {
            case .EZ:
            pair.startPair(EZActivatorParams(ssid: ssid, password: password, token: pairingToken))
            case .AP:
            pair.startPair(APActivatorParams(ssid: ssid, password: password, token: pairingToken))
        }
    }
    
    private func stop() {
        SVProgressHUD.dismiss()
        pair.stopPair()
    }
}

extension WiFiModeTableViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        SVProgressHUD.dismiss()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onError(error: Error) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: error.localizedDescription)
    }
}
