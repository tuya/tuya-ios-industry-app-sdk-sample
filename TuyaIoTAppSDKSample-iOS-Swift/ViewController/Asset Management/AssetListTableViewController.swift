//
//  AssetListTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class AssetListTableViewController: UITableViewController {
    
    var assetList = [TYVagueAsset]()
    let assetManager = TYAssetManager()

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
        cell.textLabel?.text = assetList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = storyboard!.instantiateInitialViewController() as! AssetListTableViewController
        vc.parentAssetID = assetList[indexPath.row].id
        vc.parentAssetName = assetList[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func requestAssetList(parentID: String? = nil) {
        assetManager.queryAssets(parentAssetID: parentID) { [weak self] (result, error) in
            if (result != nil) {
                guard let self = self else { return }
                self.assetList.append(contentsOf: result!.assets)
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }

}
