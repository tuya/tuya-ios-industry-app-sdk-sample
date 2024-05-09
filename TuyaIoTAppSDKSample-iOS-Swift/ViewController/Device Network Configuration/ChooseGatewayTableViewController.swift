//
//  ChooseGatewayTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryAssetKit

//protocol GatewayPayload {
//    func didFinishSelecting(_ gateway: IAssetGWDevice?)
//}

class ChooseGatewayTableViewController: UITableViewController {

//    var gatewayList: [IAssetGWDevice] = []
//    var selectedGateway: IAssetGWDevice?
//    var delegate: GatewayPayload?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        getGatewayList()
//
//        if selectedGateway == nil {
//            selectedGateway = gatewayList.first
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        delegate?.didFinishSelecting(selectedGateway)
//    }
//
//    // MARK: - Private method
//    private func getGatewayList() {
//        guard let _ = UserModel.shared.asset?.assetId else {
//            SVProgressHUD.showInfo(withStatus: "Please select asset firstly")
//            return
//        }
//
////        deviceRegistrationManager.queryRegistrationGateways(in: assetID) { gatewayList, error in
////            guard let gatewayList = gatewayList, error == nil else {
////                SVProgressHUD.showError(withStatus: error?.localizedDescription)
////                return
////            }
////
////            self.gatewayList = gatewayList
////            self.tableView.reloadData()
////        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return gatewayList.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "choose-gateway-cell")!
//        cell.textLabel?.text = gatewayList[indexPath.row].name
//
//        cell.accessoryType = selectedGateway?.deviceId == gatewayList[indexPath.row].deviceId ? .checkmark : .none
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for cell in tableView.visibleCells {
//            cell.accessoryType = .none
//        }
//
//        selectedGateway = gatewayList[indexPath.row]
//
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
