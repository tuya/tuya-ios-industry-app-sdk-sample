//
//  LoginTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class LoginTableViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if account.isEmpty || password.isEmpty {
            SVProgressHUD.showError(withStatus: "Please enter your username and password.")
            return
        }

        SVProgressHUD.show()
        TYUserManager().login(userName: account, password: password) { (isSuccess, error) in
            if isSuccess {
                SVProgressHUD.dismiss()
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.set(account, forKey: "username")
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            loginButton.sendActions(for: .touchUpInside)
        }
    }
}
