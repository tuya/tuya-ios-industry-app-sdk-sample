//
//  QRModelViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class QRModelViewController: UIViewController {
    
    var ssid: String = ""
    var password: String = ""
    var token: String = ""
    private var timer: DispatchSourceTimer! = nil
    
    @IBOutlet weak var qrImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createQRImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelRequestResult()
    }
    
    func createQRImage() {
        SVProgressHUD.show()
        guard let uid = TYUserInfo.uid else { return }
        guard let assetID = UserModel.shared.asset?.id else { return }
        TYDeviceRegistrationManager().generateToken(for: .AP, uid: uid, assetID: assetID) { [weak self] (deviceRegistrationToken, error) in
            guard let self = self else { return }
            if deviceRegistrationToken != nil {
                self.token = deviceRegistrationToken!.token
                let qrImage = try! TYQRCodeActivator(SSID: self.ssid, password: self.password, pairingToken: deviceRegistrationToken!.pairingToken).generateQRCodeUIImage(width: 200)
                self.qrImageView.image = qrImage
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    private func requestConfigResult() {
        SVProgressHUD.show()
        timer = DispatchSource.makeTimerSource()
        var number = 0
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .nanoseconds(1))
        timer.setEventHandler {
            number += 1
            if number < 100 {
                TYDeviceRegistrationManager().queryRegistrationResult(of: self.token) { (result, error) in
//                    if error != nil {
//                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
//                        return
//                    }
                    if result?.succeedDevices.count != 0 {
                        SVProgressHUD.showInfo(withStatus: "Pairing Succeed")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                self.timer.cancel()
                SVProgressHUD.show(withStatus: "Timeout")
            }
        }
        timer.activate()
    }
    
    private func cancelRequestResult() {
        guard timer != nil else {
            return
        }
        timer.cancel()
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        createQRImage()
    }
    
    @IBAction func bindButtonAction(_ sender: UIButton) {
        requestConfigResult()
    }

}
