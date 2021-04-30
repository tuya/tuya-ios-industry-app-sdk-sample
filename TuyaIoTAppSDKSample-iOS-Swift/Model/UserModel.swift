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
}




