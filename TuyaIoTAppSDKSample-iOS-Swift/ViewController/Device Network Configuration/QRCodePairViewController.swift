//
//  QRCodePairViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2022 Tuya Inc. (https://developer.tuya.com/)

import Foundation
import IndustryActivatorKit
import TuyaSmartPairingCoreKit

class QRCodePairViewController: UIViewController {
    var ssid = ""
    var password = ""
    var pairingToken = ""
    let pair = ActivatorService.shared.activator(.QRCode)
    
    var qrCodeData:Data?
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestToken()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stop()
    }
    
    private func requestToken() {
        guard let assetID = UserModel.shared.asset?.assetId else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        SVProgressHUD.show()
        ActivatorService.shared.activatorToken(assetId: assetID, longitude: nil, latitude: nil) {[weak self] token in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            self.pairingToken = token
            self.qrCodeData = ActivatorService.shared.QRCodeDataForQRCodeActivatorMode(ssid: self.ssid, password: self.password, pairToken: self.pairingToken)
            self.createQRImage()

        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func createQRImage() {
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(self.qrCodeData, forKey: "inputMessage")
            
            if let output = filter.outputImage {
                let scale = 300 / output.extent.size.width
                let qrImage = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
                self.qrCodeImage.image = UIImage(ciImage: qrImage)
            }
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        self.pair.listener = self;
        self.pair.startPair(QRCodeActivatorParams(ssid: ssid, password: password, token: pairingToken))
        SVProgressHUD.showSuccess(withStatus: "start pair, please use ipc device scan the qrcode")
    }
    
    func stop() {
        self.pair.stopPair()
        SVProgressHUD.dismiss()
    }
}

extension QRCodePairViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        SVProgressHUD.dismiss()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onError(error: Error) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}
