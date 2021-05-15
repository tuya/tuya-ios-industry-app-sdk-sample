//
//  TYDeviceManagerBaseCell.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYDeviceManagerBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)loadDataWithImage:(UIImage *)image title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
