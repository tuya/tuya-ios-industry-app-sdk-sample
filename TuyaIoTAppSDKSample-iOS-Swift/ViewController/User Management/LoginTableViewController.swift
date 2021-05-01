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
    @IBOutlet weak var locationLabel: UILabel!
    var location: String = UserDefaults.standard.value(forKey: "UserLocation") as? String ?? "China"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationLabel.text = location
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if account.isEmpty || password.isEmpty {
            SVProgressHUD.showError(withStatus: "Please enter your username and password.")
            return
        }
        
        let location = UserModel.location()
        TYSDK.initialize(clientID: AppKey.clientID, clientSecret: AppKey.clientSecret, hostRegion: location)

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
    
    private func chooseLocation() {
        let locationArray = ["China", "America", "Europe", "India", "Eastern America", "Western Europe"]
        let alert = UIAlertController(title: "", message: "Choose your location", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        for option in locationArray {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.location = option
                self.locationLabel.text = option
                UserDefaults.standard.setValue(option, forKey: "UserLocation")
            }
            alert.addAction(action)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            loginButton.sendActions(for: .touchUpInside)
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            chooseLocation()
        }
    }
}
