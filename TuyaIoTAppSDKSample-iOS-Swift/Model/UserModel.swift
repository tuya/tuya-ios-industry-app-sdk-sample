//
//  UserModel.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import IndustryAssetKit
import IndustrySpaceKit
import IndustryUserKit

class UserModel: NSObject {
    static let shared = UserModel(userName: "", asset: nil, space: nil)
    
    var userName: String
    var asset: IAsset?
    var space: ISpace?
    
    var isSpace: Bool {
        get {
            return UserService.shared().user()?.spaceType == 1
        }
    }
    
    private init(userName: String, asset: IAsset?, space: ISpace?) {
        self.userName = userName
        self.asset = asset
        self.space = space
    }
    
    public func getGid() -> String? {
        if self.isSpace {
            if let space = self.space {
                return space.spaceId
            }
        } else {
            if let asset = self.asset {
                return asset.assetId
            }
        }
        return ""
    }
}




