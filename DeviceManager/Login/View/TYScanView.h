//
//  TYScanView.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TYScanView;

@interface TYScanView : UIView

- (void)startScanning;
- (void)stopScanning;

@property (nonatomic, copy) void (^qrInfoCallBack) (NSString *string);

@end

NS_ASSUME_NONNULL_END
