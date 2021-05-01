//
//  UserModel.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaIoTAppSDK

class UserModel: NSObject {
    static let shared = UserModel(userName: "", asset: nil)
    
    var userName: String
    var asset: TYVagueAsset?
    
    private init(userName: String, asset: TYVagueAsset?) {
        self.userName = userName
        self.asset = asset
    }
    
    class func location() -> TYHostRegion {
        let location = UserDefaults.standard.string(forKey: "UserLocation") ?? "China"
        var type: TYHostRegion
        switch location {
        case "China":
            type = .CN
        case "America":
            type = .US
        case "Europe":
            type = .EU
        case "India":
            type = .IN
        case "Eastern America":
            type = .UE
        case "Western Europe":
            type = .WE
        default:
            type = .custom
        }
        return type
    }
}




