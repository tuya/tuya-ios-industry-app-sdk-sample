//
//  QRScanPairViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2022 Tuya Inc. (https://developer.tuya.com/)

import Foundation
import IndustryActivatorKit
import UIKit
import TuyaSmartPairingCoreKit

class QRScanPairViewController: UIViewController {
    var code: String = ""
    let pair = ActivatorService.shared.activator(.QRScan)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QRScan Pair"
        let barButtonItem = UIBarButtonItem.init(title: "pair", style: .plain, target: self, action: #selector(scan))
        barButtonItem.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stop()
    }
    
    func stop() {
        self.pair.stopPair()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func scan() {
        let scanVC = QRScanViewController()
        scanVC.callBack = { [weak self] (code) in
            self?.code = code ?? ""
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @IBAction func start(_ sender: Any) {
        guard self.code.count > 0 else {
            SVProgressHUD.showError(withStatus: "scan the code firstly")
            return
        }
        
        guard let assetId = UserModel.shared.asset?.assetId else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        self.pair.listener = self;
        self.pair.startPair(QRScanActivatorParams(code: self.code, assetId: assetId, ssid: nil, password: nil))
        SVProgressHUD.show()
    }
    
}

extension QRScanPairViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        self.stop()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onError(error: Error) {
        self.stop()
        SVProgressHUD.dismiss()
    }
}
