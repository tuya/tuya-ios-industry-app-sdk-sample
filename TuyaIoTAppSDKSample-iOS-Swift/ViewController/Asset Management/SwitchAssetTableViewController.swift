//
//  SwitchAssetTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class SwitchAssetTableViewController: UITableViewController {

    var assetList = [TYVagueAsset]()
    let manager = TYAssetManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestAssetList()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switch-asset-cell", for: indexPath)

        cell.textLabel?.text = assetList[indexPath.row].name
        if UserModel.shared.asset?.id == assetList[indexPath.row].id {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard UserModel.shared.asset?.id != assetList[indexPath.row].id  else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserModel.shared.asset = assetList[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func requestAssetList(_ assets: [TYVagueAsset]? = nil) {
        let tempList = assets
        
        if tempList == nil {
            performRequest()
        } else {
            tempList!.forEach { (asset) in
                performRequest(asset.id)
            }
        }
        
        if UserModel.shared.asset == nil {
            UserModel.shared.asset = self.assetList.first
        }
        
        self.tableView.reloadData()
    }
    
    private func performRequest(_ parentAssetID: String? = nil) {
        manager.queryAssets(parentAssetID: parentAssetID) { [weak self] (result, error) in
            guard let result = result else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            
            if !result.assets.isEmpty {
                self?.assetList.append(contentsOf: result.assets)
                self?.requestAssetList(result.assets)
            }
        }
    }

}
