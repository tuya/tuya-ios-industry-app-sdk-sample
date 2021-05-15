//
//  TYDeviceAssetTableViewCell.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYDeviceAssetTableViewCell : UITableViewCell

- (void)loadDataWithImageName:(nullable NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle;
- (void)loadDataWithImageName:(nullable NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle canSelect:(BOOL)canSelect;

- (void)loadDataWithImageUrl:(NSString *)imageUrl defaultImageName:(nullable NSString *)defaultImageName;
+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
