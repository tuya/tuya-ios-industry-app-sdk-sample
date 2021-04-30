//
//  LabelTableViewCell.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit

class LabelTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var selectAction: ((String) -> Void)?
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        self.selectAction?("")   
//    }
}
