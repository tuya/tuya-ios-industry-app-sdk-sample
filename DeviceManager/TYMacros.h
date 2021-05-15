//
//  TYMacros.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#ifndef TYMacros_h
#define TYMacros_h

#import <UIKit/UIKit.h>

#define kIconUrlWithIconName  @"https://images.tuyacn.com/%@"
#define local(string)        NSLocalizedString((string), nil)


typedef NS_ENUM(NSInteger,TYPairingDeviceMode) {
    TYPairingDeviceModeAP           =   0,
    TYPairingDeviceModeQRCode       =   1,
};

static inline UIColor * HexRGB(int rgbValue,float alv){
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];
    }else{
        return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];
    }
}


#endif /* TYMacros_h */
