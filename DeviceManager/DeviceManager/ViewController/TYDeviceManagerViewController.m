//
//  TYDeviceManagerViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYDeviceManagerViewController.h"
#import "TYPairingTableViewCell.h"
#import "TYAssetTableViewCell.h"
#import "TYDeviceTableViewCell.h"
#import "TYLogoutTableViewCell.h"
#import "TYAssetManagementViewController.h"
#import "TYDeviceManagementViewController.h"
#import "TYLoginDefine.h"
#import "TYLoginViewController.h"
#import "TYSelectWiFiViewController.h"

@interface TYDeviceManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *currentAssetID;
@property (nonatomic, copy) NSString *currentAssetName;

@end

@implementation TYDeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BarBackgroundImage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.view addSubview:self.tableView];
    _tableView.frame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = kStrDeviceManager;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.hidesBackButton = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = YES;
    
    _currentAssetID = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentAssetID];
    _currentAssetName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentAssetName];
    if (_currentAssetID) {
        [_tableView reloadData];
    } else {
        [SVProgressHUD show];
        @weakify(self)
        TYAssetManager *manager = [[TYAssetManager alloc] init];
        [manager queryAssetsWithParentAssetID:nil pageNumber:0 pageSize:20 completionHandle:^(TYActionableAssetsRequestResult * _Nullable result, NSError * _Nullable error) {
            if (result) {
                @strongify(self)
                self.currentAssetID = result.assets.firstObject.id;
                self.currentAssetName = result.assets.firstObject.name;
                [self.tableView reloadData];
                [[NSUserDefaults standardUserDefaults] setObject:self.currentAssetID forKey:kCurrentAssetID];
                [[NSUserDefaults standardUserDefaults] setObject:self.currentAssetName forKey:kCurrentAssetName];
            }
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *iconArray = @[@"ap_mode", @"qr_mode"];
        NSArray *titleArray = @[kStrDeviceManagerAP, kStrDeviceManagerQR];
        TYDeviceManagerBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYPairingTableViewCell cellIdentifier] forIndexPath:indexPath];
        [cell loadDataWithImage:[UIImage imageNamed:iconArray[indexPath.row]] title:titleArray[indexPath.row]];
        return cell;
    } else if (indexPath.section == 1) {
        TYAssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYAssetTableViewCell cellIdentifier] forIndexPath:indexPath];
        [cell loadDataWithImage:[UIImage imageNamed:@"asset_list"] title:self.currentAssetName detailTitle:self.currentAssetID];
        return cell;
    } else if (indexPath.section == 2) {
        TYDeviceManagerBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYDeviceTableViewCell cellIdentifier] forIndexPath:indexPath];
        [cell loadDataWithImage:[UIImage imageNamed:@"device_list"] title:kStrDeviceList];
        return cell;
    } else {
        TYLogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYLogoutTableViewCell cellIdentifier] forIndexPath:indexPath];
        [cell loadDataWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:kUsername]];
        cell.logoutBlock = ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kStrLogout message:kStrLogoutMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kStrCancel style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:kStrOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsLogin];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentAssetID];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentAssetName];
                TYLoginViewController *loginVC = [[TYLoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [nav setNavigationBarHidden:YES];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:confirmAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        TYSelectWiFiViewController *wifiVC = [[TYSelectWiFiViewController alloc] init];
        wifiVC.pairingMode = (indexPath.row == 1 ? TYPairingDeviceModeQRCode:TYPairingDeviceModeAP);
        [self.navigationController pushViewController:wifiVC animated:YES];
    } else if (indexPath.section == 1) {
        TYAssetManagementViewController *assetVC = [[TYAssetManagementViewController alloc] init];
        assetVC.navTitle = kStrAssets;
        assetVC.canSelect = NO;
        [self.navigationController pushViewController:assetVC animated:YES];
    } else if (indexPath.section == 2) {
        TYDeviceManagementViewController *deviceVC = [[TYDeviceManagementViewController alloc] init];
        [self.navigationController pushViewController:deviceVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 150;
    }
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect rect = CGRectZero;
    if (@available(iOS 13.0, *)) {
        rect = CGRectMake(0, 0, 200, 48);
    } else {
        rect = CGRectMake(32, 0, 200, 48);
    }
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.font = [UIFont systemFontOfSize:22];
    label.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = kStrDevicePairing;
    } else if (section == 1) {
        label.text = kStrAssetManagement;
    } else if (section == 2) {
        label.text = kStrDeviceManagement;
    } else {
        label.text = nil;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }
    return 48;
}

#pragma mark - Set/Get Method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:@available(iOS 13.0, *) ? UITableViewStyleInsetGrouped : UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = HexRGB(0xC9C9C9, 1.0f);
        _tableView.backgroundColor = HexRGB(0xF7F8F9, 1.0f);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TYPairingTableViewCell class] forCellReuseIdentifier:[TYPairingTableViewCell cellIdentifier]];
        [_tableView registerClass:[TYAssetTableViewCell class] forCellReuseIdentifier:[TYAssetTableViewCell cellIdentifier]];
        [_tableView registerClass:[TYDeviceTableViewCell class] forCellReuseIdentifier:[TYDeviceTableViewCell cellIdentifier]];
        [_tableView registerClass:[TYLogoutTableViewCell class] forCellReuseIdentifier:[TYLogoutTableViewCell cellIdentifier]];
    }
    return _tableView;
}

@end
