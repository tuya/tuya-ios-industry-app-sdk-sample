//
//  AssetListTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryAssetKit

class AssetListTableViewController: UITableViewController {
    
    var assetList = [IAsset]()

    var parentAssetID: String?
    var parentAssetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let parentAssetName = parentAssetName {
            navigationItem.title = parentAssetName
        }
        
        requestAssetList(parentID: parentAssetID)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "asset-list-cell", for: indexPath)
        let asset = assetList[indexPath.row]

        cell.textLabel?.text = asset.assetName
        cell.detailTextLabel?.text = "sub asset count \(asset.currentSubAssetNum), device count \(asset.currentAssetDeviceNum)"
        
        if (asset.currentSubAssetNum > 0) {
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator

        }else{
            cell.textLabel?.textColor = UIColor.lightGray
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let asset = assetList[indexPath.row]
        if (asset.currentSubAssetNum == 0) {return}
        
        let vc = storyboard!.instantiateInitialViewController() as! AssetListTableViewController
        vc.parentAssetID = assetList[indexPath.row].assetId
        vc.parentAssetName = assetList[indexPath.row].assetName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func requestAssetList(parentID: String? = nil) {
        AssetService.shared.subAssets(assetId: parentID) {[weak self] assets in
            guard let self = self else { return }
            self.assetList.append(contentsOf: assets)
            self.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }

}
