//
//  TuyaSmartMainTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class TuyaSmartMainTableViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameDetailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var currentHomeLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        initiateCurrentAsset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentHomeLabel.text = UserModel.shared.asset?.name
        let name = UserDefaults.standard.string(forKey: "username")
        userNameDetailLabel.text = "\(name!)"
        
        if #available(iOS 13.0, *) {
            currentHomeLabel.textColor = .secondaryLabel
        } else {
            currentHomeLabel.textColor = .systemGray
        }
    }
    
    // MARK: - Private Method
    private func initiateCurrentAsset() {
        TYAssetManager().queryAssets { [weak self] (result, error) in
            if (result != nil) {
                UserModel.shared.asset = result?.assets.first
                self?.currentHomeLabel.text = UserModel.shared.asset?.name
                self?.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func logoutTapped(_ sender: UIButton) {
        let alertViewController = UIAlertController(title: nil, message: NSLocalizedString("You're going to log out this account.", comment: "User tapped the logout button."), preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Confirm logout.", style: .destructive) { (action) in
            UserDefaults.standard.set(false, forKey: "isLogin")
            UserDefaults.standard.setValue("", forKey: "username")
            UserDefaults.standard.removeObject(forKey: "UserLocation")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "APMode":
            let vc = segue.destination as! NetworkInformationTableViewController
            vc.pairingType = .AP
            break
        case "QRMode":
            let vc = segue.destination as! NetworkInformationTableViewController
            vc.pairingType = .QR
            break
        default:
            break
        }
    }

}
