//
//  AppDelegate.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "AppDelegate.h"
#import "TYLoginViewController.h"
#import "TYLoginDefine.h"
#import "TYDeviceManagerViewController.h"
#import "TYScanTipViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setBackgroundColor:HexRGB(0x000000, 0.6f)];
    [SVProgressHUD setForegroundColor:HexRGB(0xffffff, 1.0f)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:16.0f]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"toast_info"]];
    
    NSString *clientID = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessId];
    NSString *clientSecret = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessSecret];
    NSInteger region = [[NSUserDefaults standardUserDefaults] integerForKey:kLocation];
#if DEBUG
    [TYSDK setIsDebugMode:YES];
#endif
    [TYSDK initializeWithClientID:clientID clientSecret:clientSecret hostRegion:region];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (@available(iOS 13, *)) {
        // Will go into scene delegate
    } else {
        UIViewController *mainVC;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
            mainVC = [[TYDeviceManagerViewController alloc] init];
        } else {
            NSString *accessID = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessId];
            NSString *secret = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessSecret];
            if (accessID && secret) {
                mainVC = [[TYLoginViewController alloc] init];
            } else {
                mainVC = [[TYScanTipViewController alloc] init];
            }
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        [nav setNavigationBarHidden:YES];
        self.window.rootViewController = nav;
    }
    
    [[UIApplication sharedApplication] delegate].window = self.window;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
