//
//  SceneDelegate.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "SceneDelegate.h"
#import "TYLoginViewController.h"
#import "TYLoginDefine.h"
#import "TYDeviceManagerViewController.h"
#import "TYScanTipViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
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
    
    [[UIApplication sharedApplication] delegate].window = self.window;
    [self.window makeKeyAndVisible];
}


@end
