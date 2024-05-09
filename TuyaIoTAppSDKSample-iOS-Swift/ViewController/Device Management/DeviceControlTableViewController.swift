//
//  DeviceControlTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryDeviceKit

class DeviceControlTableViewController: UITableViewController {

    // MARK: - Property
    var device: IDevice?
    var dpIds: [String]?
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
    
    private func requestData() {
        let group = DispatchGroup()

        SVProgressHUD.show()
        if let keys = self.device?.schemas?.keys {
            self.dpIds = Array(keys).sorted(by: { str1, str2 in
                return str1 < str2
            })
        }
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
        group.notify(queue: .main) {
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dpIds?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        guard let device = self.device else {
            return defaultCell
        }
        
        guard let dpIds = dpIds else {
            return defaultCell
        }

        let dpId = dpIds[indexPath.row]
        guard let dpSchema = device.schemas?[dpId] else {
            return defaultCell
        }
        
        guard let dpsTemp = device.dps?[dpId] else {
            return defaultCell
        }
        
        let dps = String(describing: dpsTemp)
        
        let type = dpSchema.type
        var cellIdentifier = DeviceControlCell.cellIdentifier(with: type)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.rawValue)!
        if dpSchema.mode == "ro" {
            cellIdentifier = .labelCell
            cell = tableView.dequeueReusableCell(withIdentifier: "device-label-cell")!
        }
        
        switch cellIdentifier {
        case .switchCell:
            guard let cell = cell as? SwitchTableViewCell else { break }

            cell.label.text = dpSchema.name
            cell.switchButton.isOn = dps == "1" ? true : false
            cell.switchAction = { btn in
                let command = DpCommand(dps: [Dp(dpId: dpId, booleanValue: btn.isOn)], publishMode: DpsPublishMode.auto)
                device.publish(dps: command) {} failure: { error in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }

        case .sliderCell:
            guard let cell = cell as? SliderTableViewCell else { break }
            let property = dpSchema.property
            let min = property.min
            let max = property.max
            let value = dps

            cell.slider.minimumValue = Float(min)
            cell.slider.maximumValue = Float(max)
            cell.slider.isContinuous = false
            cell.slider.value = Float(value)!
            cell.label.text = dpSchema.name
            cell.detailLabel.text = String(cell.slider.value)
            cell.sliderAction = { slider in
                let value = Int(slider.value)
                cell.detailLabel.text = String(value)
                let command = DpCommand(dps: [Dp(dpId: dpId, intValue: value)], publishMode: DpsPublishMode.auto)
                device.publish(dps: command) {} failure: { error in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }

        case .enumCell:
            guard let cell = cell as? EnumTableViewCell else { break }
            let property = dpSchema.property
            cell.label.text = dpSchema.name
            cell.optionArray = property.range ?? [String]()
            cell.currentOption = dps

            cell.selectAction = { option in
                let command = DpCommand(dps: [Dp(dpId: dpId, stringValue: option)], publishMode: DpsPublishMode.auto)
                device.publish(dps: command) {} failure: { error in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }

        case .stringCell:
            guard let cell = cell as? StringTableViewCell else { break }
            cell.label.text = dpSchema.name
            cell.textField.text = dps

        case .labelCell:
            guard let cell = cell as? LabelTableViewCell else { break }
            cell.label.text = dpSchema.name
            cell.detailLabel.text = dps
        }
        return cell
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

