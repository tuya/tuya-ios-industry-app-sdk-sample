//
//  TYScanViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYScanViewController.h"
#import "TYScanView.h"
#import "TYLoginDefine.h"
#import "TYLoginViewController.h"
#import "TYQREncode.h"

@interface TYScanViewController ()

@property (nonatomic, strong) TYScanView *scanView;

@end

@implementation TYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self.scanView startScanning];
    
    @weakify(self)
    _scanView.qrInfoCallBack = ^(NSString * _Nonnull string) {
        @strongify(self)
        NSDictionary *dict = [TYQREncode infoFromEncryptString:string];
        if ([dict.allKeys containsObject:@"accessId"] || [dict.allKeys containsObject:@"accessSecret"]) {
            [[NSUserDefaults standardUserDefaults] setValue:dict[@"accessId"] forKey:kAccessId];
            [[NSUserDefaults standardUserDefaults] setValue:dict[@"accessSecret"] forKey:kAccessSecret];
            
            [SVProgressHUD showSuccessWithStatus:kStrSuccess];
            
            TYLoginViewController *loginVC = [[TYLoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [nav setNavigationBarHidden:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } else {
            [self.scanView startScanning];
            [SVProgressHUD showErrorWithStatus:kStrFail];
        }
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
    [self.view addSubview:self.scanView];
}

#pragma mark - get

- (TYScanView *)scanView{
    if (!_scanView) {
        _scanView = [[TYScanView alloc] initWithFrame:self.view.bounds];
    }
    return _scanView;
}

@end
