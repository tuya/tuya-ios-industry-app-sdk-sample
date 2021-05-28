//
//  WiredModeViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class WiredModeViewController: UIViewController {
    
    private var pairingToken = ""
    
    private var token = ""
    
    private var timer: DispatchSourceTimer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestToken()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.cancel()
        timer = nil
        SVProgressHUD.dismiss()
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        let activator = TYWiredActivator(pairingToken: pairingToken)
        activator.start(timeout: 120) { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        SVProgressHUD.show(withStatus: "Searching...")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.requestConfigResult()
        }
    }
    
    // MARK: - Private Method
    private func requestToken() {
        guard let assetID = UserModel.shared.asset?.id else {
            SVProgressHUD.showInfo(withStatus: "Please login again")
            return
        }
        
        TYDeviceRegistrationManager().generateToken(for: .AP, uid: TYUserInfo.uid!, assetID: assetID) { [weak self] (deviceRegistrationToken, error) in
            guard let self = self else { return }
            if deviceRegistrationToken != nil {
                self.pairingToken = deviceRegistrationToken!.pairingToken
                self.token = deviceRegistrationToken!.token
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
        
    }
    
    private func requestConfigResult() {
        timer = DispatchSource.makeTimerSource()
        var number = 0
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .nanoseconds(1))
        timer.setEventHandler {
            number += 1
            if number < 100 {
                TYDeviceRegistrationManager().queryRegistrationResult(of: self.token) { (result, error) in
//                    if result != nil {
                        if result?.succeedDevices.count != 0 {
                            SVProgressHUD.showInfo(withStatus: "Pair device successfully")
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
//                        if result?.failedDevices.count != 0 {
//                            SVProgressHUD.showInfo(withStatus: "Pairing Failed")
//                        }
                       
//                    } else {
//                        SVProgressHUD.show(withStatus: "Pairing Failed")
//                    }
                }
            } else {
                self.timer.cancel()
                SVProgressHUD.show(withStatus: "Timeout")
            }
        }
        timer.activate()
    }
    
}
