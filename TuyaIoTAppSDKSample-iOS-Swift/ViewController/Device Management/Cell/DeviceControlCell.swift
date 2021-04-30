//
//  DeviceControlCell.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import Foundation
//import TuyaSmartDeviceKit

enum DeviceControlCell: String {
    case switchCell = "device-switch-cell"
    case sliderCell = "device-slider-cell"
    case enumCell = "device-enum-cell"
    case stringCell = "device-string-cell"
    case labelCell = "device-label-cell"
    
    static func cellIdentifier(with type: String) -> Self {

        switch type {
        case "Boolean":
            return Self.switchCell
        case "Enum":
            return Self.enumCell
        case "value", "Integer":
            return Self.sliderCell
        case "string":
            return Self.stringCell
        case "Json":
            return Self.labelCell
    
        default:
            return Self.labelCell
        }
    }
    
    /*
     type:
     Integer
     Json
     
     
     */
    // temp
//    static func cellIdentifier(with schema: Any) -> Self {
//        return self.labelCell
//
//    }
}
