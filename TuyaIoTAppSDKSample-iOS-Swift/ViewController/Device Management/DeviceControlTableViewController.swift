//
//  DeviceControlTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class DeviceControlTableViewController: UITableViewController {

    // MARK: - Property
    var device: TYDevice?
    var instruction: TYCategoryStandardCommand?
    var functionsList = [TYStandardCommand]()
    var statusList = [TYDeviceCommand]()
    var newCommand: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = device?.name
        
        requestData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show-device-detail" else { return }
        let vc = segue.destination as! DeviceDetailTableViewController
        vc.device = device
    }
    
    // MARK: -  Private Method
    private func publishMessage(with dps: TYDeviceCommand) {
        TYDeviceManager().sendCommands([dps], to: device!.id) { (bool, error) in
            if bool == false {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                } else {
                    SVProgressHUD.showInfo(withStatus: "Succeed sent command")
                }
            }
        }
        
    }
    
    private func requestData() {
        let group = DispatchGroup()

        SVProgressHUD.show()
        requestStatusFromDeviceID(group)
        requestInstructionSetFromDeviceID(group)
        group.notify(queue: .main) {
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    
    private func requestStatusFromDeviceID(_ group: DispatchGroup) {
        group.enter()
        TYDeviceManager().queryDeviceStatus(of: device!.id) { [ weak self ] (commandArray, error) in
            guard let self = self else { return }
            if commandArray!.count > 0 {
                self.statusList = commandArray!
            }
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            group.leave()
        }
    }
    
    private func requestInstructionSetFromDeviceID(_ group: DispatchGroup) {
        group.enter()
        TYDeviceManager().queryCommandSetFromDeviceID(device!.id) { [ weak self ] (instruction, error) in
            guard let self = self else { return }
            if instruction != nil {
                self.instruction = instruction
                self.functionsList = instruction!.functions
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            group.leave()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(statusList.count, functionsList.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        guard functionsList.count != 0 else { return defaultCell }
        guard statusList.count != 0 else { return defaultCell }
        
        let standardInstruction = functionsList[indexPath.row]
        let key = standardInstruction.code
        var command = TYDeviceCommand(code: "", value: "")
        statusList.forEach { (model) in
            if model.code == key {
                command = model
            }
        }
        
        let type = standardInstruction.type
        let cellIdentifier = DeviceControlCell.cellIdentifier(with: type)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.rawValue)!
        switch cellIdentifier {
        case .switchCell:
            guard let cell = cell as? SwitchTableViewCell else { break }

            cell.label.text = standardInstruction.name
            cell.switchButton.isOn = command.value as? String == "true" ? true : false
            cell.switchAction = { [weak self] switchButton in
                guard let self = self else { return }
                
                let model = TYDeviceCommand(code: standardInstruction.code, value: switchButton.isOn ? true : false)
                self.publishMessage(with: model)
            }

        case .sliderCell:
            guard let cell = cell as? SliderTableViewCell else { break }
            let dict = convertToDictionary(text: standardInstruction.values)
            
            let min = dict?["min"] as? String ?? "0"
            let max = dict?["max"] as? String ?? "255"
            let value = command.value as? String ?? "0"
            
            cell.slider.minimumValue = Float(min)!
            cell.slider.maximumValue = Float(max)!
            cell.slider.isContinuous = false
            cell.slider.value = Float(value)!
            cell.label.text = standardInstruction.name
            cell.detailLabel.text = String(cell.slider.value)
            cell.sliderAction = { [weak self] slider in
                guard let self = self else { return }
                
                let value = Int(slider.value)
                cell.detailLabel.text = String(value)
                let model = TYDeviceCommand(code: standardInstruction.code, value: value)
                self.publishMessage(with: model)
            }

        case .enumCell:
            guard let cell = cell as? EnumTableViewCell else { break }
            let string = String(standardInstruction.values)
            let dict = convertToDictionary(text: string)
            cell.label.text = standardInstruction.name
            cell.optionArray = dict!["range"] as! [String]
            cell.currentOption = command.value as? String
            
            cell.selectAction = { [weak self] option in
                guard let self = self else { return }
                let model = TYDeviceCommand(code: standardInstruction.code, value: option)
                self.publishMessage(with: model)
            }

        case .stringCell:
            guard let cell = cell as? StringTableViewCell else { break }
            cell.label.text = standardInstruction.name
            cell.textField.text = command.value as? String
            
        case .labelCell:
            guard let cell = cell as? LabelTableViewCell else { break }
            cell.label.text = standardInstruction.name
        }
        return cell
    }
    
    private func editNewCommandAndSend(code: String, command: String!) {
        let alertVC = UIAlertController.init(title: "", message: "Input new command", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.text = command
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let model = TYDeviceCommand(code: code, value: self.newCommand as Any)
            self.publishMessage(with: model)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standardInstruction = functionsList[indexPath.row]
        if standardInstruction.type != "Json" { return }
        let key = standardInstruction.code
        var command = TYDeviceCommand(code: "", value: "")
        statusList.forEach { (model) in
            if model.code == key {
                command = model
            }
        }
        editNewCommandAndSend(code: command.code, command: command.value as? String)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        newCommand = textField.text!
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}

