//
//  TuyaSmartMainTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustrySpaceKit
import IndustryAssetKit
import IndustryUserKit
import IndustryAuthKit

enum PairingMode: Int {
    case EZ = 0
    case AP
    case Wired
    case QRCode
    case QRScan
    case Bluetooth
    case BluetoothDual
}

class TuyaSmartMainTableViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameDetailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var currentHomeLabel: UILabel!
    
    @IBOutlet weak var currentSpaceLabel: UILabel!
    
    var isSpace: Bool = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInvalid), name: .industryAuthKitDidUnauth, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInvalid), name: .industryAuthKitAuthDidInvalid, object: nil)
        
        isSpace = UserService.shared().user()?.spaceType == 1
        
        if isSpace {
            NSLog("isSpace true.")
            initiateCurrentSpace()
        } else {
            NSLog("isSpace false.")
            initiateCurrentAsset()
        }
    }
    
    @objc func sessionInvalid() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isSpace {
            currentSpaceLabel.text = UserModel.shared.space?.spaceName
        } else {
            currentHomeLabel.text = UserModel.shared.asset?.assetName
        }
        
        let name = UserService.shared().user()?.userName
        userNameDetailLabel.text = "\(name!)"
        
        if #available(iOS 13.0, *) {
            currentHomeLabel.textColor = .secondaryLabel
            currentSpaceLabel.textColor = .secondaryLabel
        } else {
            currentHomeLabel.textColor = .systemGray
            currentSpaceLabel.textColor = .systemGray
        }
    }
    
    // MARK: - Private Method
    private func initiateCurrentAsset() {
        AssetService.shared.subAssets(assetId: nil) {[weak self] assets in
            UserModel.shared.asset = assets.first
            self?.currentHomeLabel.text = UserModel.shared.asset?.assetName
            self?.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    private func initiateCurrentSpace() {
        SpaceService.shared.subSpaces(spaceId: nil) {[weak self] spaces in
            UserModel.shared.space = spaces.first
            self?.currentSpaceLabel.text = UserModel.shared.space?.spaceName
            self?.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    // MARK: - IBAction
    @IBAction func logoutTapped(_ sender: UIButton) {
        let alertViewController = UIAlertController(title: nil, message: NSLocalizedString("You're going to log out this account.", comment: "User tapped the logout button."), preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Confirm logout.", style: .destructive) { (action) in
            
            UserService.shared().logoutSuccess {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
            } failure: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel)
        
        alertViewController.popoverPresentationController?.sourceView = sender

        alertViewController.addAction(logoutAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Logout button row tapped
        if indexPath.section == 0 && indexPath.row == 1 {
            logoutButton.sendActions(for: .touchUpInside)
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case PairingMode.Bluetooth.rawValue:
                let bluetoothVC = BluetoothModeViewController.init()
                self.navigationController?.pushViewController(bluetoothVC, animated: true)
            case PairingMode.BluetoothDual.rawValue:
                let bleDualVC = BluetoothDualModeViewController.init()
                self.navigationController?.pushViewController(bleDualVC, animated: true)
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "EZMode":
            let vc = segue.destination as! NetworkInformationTableViewController
            vc.pairingType = .EZ
            break
        case "APMode":
            let vc = segue.destination as! NetworkInformationTableViewController
            vc.pairingType = .AP
            break
        case "QRCodeMode":
            let vc = segue.destination as! NetworkInformationTableViewController
            vc.pairingType = .QRCode
        default:
            break
        }
    }

}
