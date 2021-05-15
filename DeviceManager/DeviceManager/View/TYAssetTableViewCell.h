//
//  TYAssetTableViewCell.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYDeviceManagerBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAssetTableViewCell : TYDeviceManagerBaseCell

- (void)loadDataWithImage:(UIImage *)image title:(NSString *)title detailTitle:(NSString *)detailTitle;

+ (NSString *)cellIdentifier;
    
@end

NS_ASSUME_NONNULL_END
