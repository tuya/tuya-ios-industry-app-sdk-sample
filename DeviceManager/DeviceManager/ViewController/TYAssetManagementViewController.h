//
//  TYAssetManagementViewController.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYAssetManagementViewController : UIViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, strong) TYVagueAsset *asset;
@property (nonatomic, assign) BOOL canSelect;

@end

NS_ASSUME_NONNULL_END
