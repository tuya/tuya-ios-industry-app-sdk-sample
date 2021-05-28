//
//  ZigbeeSubdeviceTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class ZigbeeSubdeviceTableViewController: UITableViewController, GatewayPayload {
    @IBOutlet weak var gatewayNameLabel: UILabel!
    
    // MARK: - Property
    var gateway: TYGateway?
    let deviceRegistrationManager = TYDeviceRegistrationManager()
    var time: TimeInterval = 0
    
    private var timer: DispatchSourceTimer! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gatewayNameLabel.text = gateway?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.cancel()
        timer = nil
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "choose-gateway-segue",
              let vc = segue.destination as? ChooseGatewayTableViewController
        else { return }
        
        vc.selectedGateway = gateway
        vc.delegate = self
    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        guard let gateway = gateway else {
            Alert.showBasicAlert(on: self, with: "Select Zigbee Gateway", message: "You must have one Zigbee gateway selected.")
            return
        }
        
        SVProgressHUD.show(withStatus: NSLocalizedString("Configuring", comment: ""))
        
        time = Date().timeIntervalSince1970
        
        deviceRegistrationManager.discoverSubDevices(gatewayDeviceID: gateway.id) { success, error in
            guard success else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            self.searchSubDevice(gatewayDeviceID: gateway.id)
        }
    }
    
    private func searchSubDevice(gatewayDeviceID: String) {
        timer = DispatchSource.makeTimerSource()
        var number = 0
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .nanoseconds(1))
        timer.setEventHandler {
            number += 1
            if number < 100 {
                self.deviceRegistrationManager.querySubDeviceRegistrationResult(gatewayDeviceID: gatewayDeviceID, discoveryTime: self.time) { deviceList, error in
//                    if result != nil {
                        if deviceList?.count != 0 {
                            SVProgressHUD.showInfo(withStatus: "Pairing Succeed")
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
    
    func didFinishSelecting(_ gateway: TYGateway?) {
        self.gateway = gateway
    }
  
}
