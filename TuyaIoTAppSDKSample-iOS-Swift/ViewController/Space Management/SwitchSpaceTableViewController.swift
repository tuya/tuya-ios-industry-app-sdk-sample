//
//  SwitchSpaceTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2024 Tuya Inc. (https://developer.tuya.com/)

import Foundation
import IndustrySpaceKit

class SwitchSpaceTableViewController: UITableViewController {

    var spaceList = [ISpace]()
    var spaceId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "AddSpace", style: .plain, target: self, action: #selector(addSpace))
        self.tableView.register(SwitchSpaceTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SwitchSpaceTableViewCell.self))
        requestSpaceList()
    }
    
    @objc func addSpace() {
        var curTextField = UITextField.init()
        
        let alert = UIAlertController.init(title: "AddSpace", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "please enter space name"
            curTextField = textField
        }
        
        let confirm = UIAlertAction.init(title: "confirm", style: .default) { alert in
            if let text = curTextField.text, text.count > 0 {
                SVProgressHUD.show()
                SpaceService.shared.create(name: text, parentSpaceId: self.spaceId) {
                    // The cloud will do some asynchronous operations, and you need to use mqtt messages later
                    sleep(1)
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "add success")
                    self.requestSpaceList()
                } failure: { error in
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
                return
            }
            
            SVProgressHUD.showInfo(withStatus: "please enter space name")
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
        return spaceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SwitchSpaceTableViewCell.self), for: indexPath)
        
        if let switchSpaceTableViewCell = cell as? SwitchSpaceTableViewCell {
            switchSpaceTableViewCell.modifyBlock = { [weak self] (space) in
                guard let self = self else {
                    return
                }
                
                guard let space = space else {
                    return
                }

                var curTextField = UITextField.init()
                
                let alert = UIAlertController.init(title: "Modify Space Name", message: nil, preferredStyle: .alert)
                
                alert.addTextField { textField in
                    textField.placeholder = "please enter space name"
                    curTextField = textField
                }
                
                let confirm = UIAlertAction.init(title: "confirm", style: .default) { alert in
                    if let text = curTextField.text, text.count > 0 {
                        SVProgressHUD.show()
                        SpaceService.shared.update(spaceId: space.spaceId, name: text) {
                            self.requestSpaceList()
                        } failure: { error in
                            SVProgressHUD.showError(withStatus: error.localizedDescription)
                        }
                    }
                    
                    SVProgressHUD.showInfo(withStatus: "please enter space name")
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
        guard let cell = cell as? SwitchSpaceTableViewCell else {
            return
        }
        
        cell.textLabel?.text = spaceList[indexPath.row].spaceName
        cell.space = self.spaceList[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctr = storyboard!.instantiateInitialViewController() as! SwitchSpaceTableViewController
        ctr.spaceId = self.spaceList[indexPath.row].spaceId
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
        let spaceId = self.spaceList[indexPath.row].spaceId
        SpaceService.shared.remove(spaceId: spaceId) {
            SVProgressHUD.dismiss()
            self.spaceList.remove(at: indexPath.row)
            self.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @objc private func requestSpaceList() {
        SVProgressHUD.show()
        SpaceService.shared.subSpaces(spaceId: self.spaceId) {[weak self] spaces in
            SVProgressHUD.dismiss()
            if spaces.count > 0 {
                if UserModel.shared.space == nil {
                    UserModel.shared.space = self?.spaceList.first
                }
                self?.spaceList = spaces
                self?.tableView.reloadData()
            }
        } failure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
}

typealias SModifyBlock = (_ space:ISpace?)->Void
class SwitchSpaceTableViewCell: UITableViewCell {
    let btn:UIButton = UIButton.init(type: .custom)
    let modifyBtn:UIButton = UIButton.init(type: .custom)
    var space:ISpace?
    var modifyBlock:SModifyBlock?
    
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
        
        self.btn.addTarget(self, action: #selector(selectSpace), for: .touchUpInside)
        
        self.contentView.addSubview(self.modifyBtn)
        self.modifyBtn.setImage(UIImage.init(systemName: "pencil"), for: .normal)
        self.modifyBtn.frame = CGRect.init(x: UIScreen.main.bounds.size.width - 90, y: 5, width: 60, height: self.bounds.size.height - 10)
        self.modifyBtn.addTarget(self, action: #selector(modifySpace), for: .touchUpInside)
    }
    
    @objc func selectSpace() {
        UserModel.shared.space = space
        SVProgressHUD.showSuccess(withStatus: "set success")
    }
    
    @objc func modifySpace() {
        self.modifyBlock?(self.space)
    }
}

