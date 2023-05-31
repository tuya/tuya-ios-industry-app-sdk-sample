//
//  SwitchAssetTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryAssetKit

class SwitchAssetTableViewController: UITableViewController {

    var assetList = [IAsset]()
    var assetId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "AddAsset", style: .plain, target: self, action: #selector(addAsset))
        self.tableView.register(SwitchAssetTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SwitchAssetTableViewCell.self))
        requestAssetList()
    }
    
    @objc func addAsset() {
        var curTextField = UITextField.init()
        
        let alert = UIAlertController.init(title: "AddAsset", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "please enter asset name"
            curTextField = textField
        }
        
        let confirm = UIAlertAction.init(title: "confirm", style: .default) { alert in
            if let text = curTextField.text, text.count > 0 {
                SVProgressHUD.show()
                AssetService.shared.create(name: text, parentAssetId: self.assetId) {
                    // The cloud will do some asynchronous operations, and you need to use mqtt messages later
                    sleep(1)
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "add success")
                    self.requestAssetList()
                } failure: { error in
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
                return
            }
            
            SVProgressHUD.showInfo(withStatus: "please enter asset name")
        }
        alert.addAction(confirm)
        
        let cancel = UIAlertAction.init(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SwitchAssetTableViewCell.self), for: indexPath)
        
        if let switchAssetTableViewCell = cell as? SwitchAssetTableViewCell {
            switchAssetTableViewCell.modifyBlock = { [weak self] (asset) in
                guard let self = self else {
                    return
                }
                
                guard let asset = asset else {
                    return
                }

                var curTextField = UITextField.init()
                
                let alert = UIAlertController.init(title: "Modify Asset Name", message: nil, preferredStyle: .alert)
                
                alert.addTextField { textField in
                    textField.placeholder = "please enter asset name"
                    curTextField = textField
                }
                
                let confirm = UIAlertAction.init(title: "confirm", style: .default) { alert in
                    if let text = curTextField.text, text.count > 0 {
                        SVProgressHUD.show()
                        AssetService.shared.update(assetId: asset.assetId, name: text) {
                            self.requestAssetList()
                        } failure: { error in
                            SVProgressHUD.showError(withStatus: error.localizedDescription)
                        }
                    }
                    
                    SVProgressHUD.showInfo(withStatus: "please enter asset name")
                }
                alert.addAction(confirm)
                
                let cancel = UIAlertAction.init(title: "cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SwitchAssetTableViewCell else {
            return
        }
        
        cell.textLabel?.text = assetList[indexPath.row].assetName
        cell.asset = self.assetList[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctr = storyboard!.instantiateInitialViewController() as! SwitchAssetTableViewController
        ctr.assetId = self.assetList[indexPath.row].assetId
        self.navigationController?.pushViewController(ctr, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        SVProgressHUD.show()
        let assetId = self.assetList[indexPath.row].assetId
        AssetService.shared.remove(assetId: assetId) {
            SVProgressHUD.dismiss()
            self.assetList.remove(at: indexPath.row)
            self.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @objc private func requestAssetList() {
        SVProgressHUD.show()
        AssetService.shared.subAssets(assetId: self.assetId) {[weak self] assets in
            SVProgressHUD.dismiss()
            if assets.count > 0 {
                if UserModel.shared.asset == nil {
                    UserModel.shared.asset = self?.assetList.first
                }
                self?.assetList = assets
                self?.tableView.reloadData()
            }
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
}

typealias ModifyBlock = (_ asset:IAsset?)->Void
class SwitchAssetTableViewCell: UITableViewCell {
    let btn:UIButton = UIButton.init(type: .custom)
    let modifyBtn:UIButton = UIButton.init(type: .custom)
    var asset:IAsset?
    var modifyBlock:ModifyBlock?
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.contentView.addSubview(self.btn)
        self.btn.setTitle("select", for: .normal)
        self.btn.setTitleColor(UIColor.black, for: .normal)
        self.btn.frame = CGRect.init(x: UIScreen.main.bounds.size.width - 150, y: 5, width: 100, height: self.bounds.size.height - 10)
        
        self.btn.addTarget(self, action: #selector(selectAsset), for: .touchUpInside)
        
        self.contentView.addSubview(self.modifyBtn)
        self.modifyBtn.setImage(UIImage.init(systemName: "pencil"), for: .normal)
        self.modifyBtn.frame = CGRect.init(x: UIScreen.main.bounds.size.width - 90, y: 5, width: 60, height: self.bounds.size.height - 10)
        self.modifyBtn.addTarget(self, action: #selector(modifyAsset), for: .touchUpInside)
    }
    
    @objc func selectAsset() {
        UserModel.shared.asset = asset
        SVProgressHUD.showSuccess(withStatus: "set success")
    }
    
    @objc func modifyAsset() {
        self.modifyBlock?(self.asset)
    }
}
