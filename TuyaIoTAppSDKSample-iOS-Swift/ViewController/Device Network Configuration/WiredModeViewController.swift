//
//  WiredModeViewController.swift
//  ThingIoTAppSDK
//
//  Copyright (c) 2014-2021 Thing Inc. (https://developer.tuya.com/)

import UIKit
import IndustryActivatorKit
import ThingSmartPairingCoreKit

class WiredModeViewController: UIViewController {
    private var pairingToken = ""
    var pair = ActivatorService.shared.activator(.WiredGateway)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stop()
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        guard let assetID = UserModel.shared.getGid() else {
            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
            return
        }
        
        SVProgressHUD.show()
        ActivatorService.shared.activatorToken(assetId: assetID, longitude: nil, latitude: nil) { [weak self] token in
            guard let self = self else { return }
            self.pairingToken = token
            self.start()
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    // MARK: - Private Method
    private func start() {
        self.pair.listener = self
        self.pair.startPair(WiredGatewayActivatorParams(token: pairingToken))
    }
    
    private func stop() {
        SVProgressHUD.dismiss()
        self.pair.stopPair()
    }
}

extension WiredModeViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?) {
        SVProgressHUD.dismiss()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onError(error: Error) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: error.localizedDescription)
    }
}
