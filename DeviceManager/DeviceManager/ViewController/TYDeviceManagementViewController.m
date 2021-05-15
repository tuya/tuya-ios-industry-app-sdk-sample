//
//  TYDeviceManagementViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYDeviceManagementViewController.h"
#import "TYDeviceAssetTableViewCell.h"
#import "TYLoginDefine.h"
#import <MJRefresh/MJRefresh.h>

@interface TYDeviceCellModel : NSObject

@property (nonatomic, strong) TYVagueDevice *device;

@property (nonatomic, strong) NSString *iconUrl;

@end

@implementation TYDeviceCellModel

@end

@interface TYDeviceManagementViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TYDeviceManager *deviceManager;

@property (nonatomic, strong) TYAssetManager *assetManager;

@property (nonatomic, strong) NSMutableArray<TYDeviceCellModel *> * devices;

@property (nonatomic, copy) NSString *lastRowKey;

@property (nonatomic, assign) BOOL hasNextResult;

@end

@implementation TYDeviceManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = kStrDeviceList;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.lastRowKey = nil;
    [self setUI];
    [self configureData];
}

#pragma mark - private method
- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)configureData{
    NSString *assetId = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentAssetID];
    @weakify(self)
    [self.assetManager queryDevicesIn:assetId pageSize:20 lastRowKey:self.lastRowKey completionHandle:^(TYDevicesRequestResult * _Nullable result, NSError * _Nullable error) {
        @strongify(self)
        [self handleDeviceListWithResult:result error:error];
    }];
}

- (void)handleDeviceListWithResult:(TYDevicesRequestResult *)result error:(NSError *)error{
    if (error) {
        [self.tableView.mj_footer resetNoMoreData];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    } else if (result.devices.count == 0){
        [SVProgressHUD showSuccessWithStatus:kStrDeviceNone];
    } else {
        [SVProgressHUD dismiss];
        self.lastRowKey = result.lastRowKey;
        self.hasNextResult = result.hasNextResult;
                
        NSMutableArray <TYDeviceCellModel *>*array = [NSMutableArray array];
        [result.devices enumerateObjectsUsingBlock:^(TYVagueDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TYDeviceCellModel *cellModel = [[TYDeviceCellModel alloc] init];
            cellModel.device = obj;
            [array addObject:cellModel];
        }];
        [self.devices addObjectsFromArray:array];
        
        if (!self.hasNextResult) {
            @weakify(self)
            [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
                @strongify(self)
                self.tableView.mj_footer = nil;
            }];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - action
- (void)actionPull{
    if (self.hasNextResult && self.lastRowKey) {
        [self configureData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDeviceAssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYDeviceAssetTableViewCell cellIdentifier] forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 16.0f, 0, 16.0f);
    
    TYDeviceCellModel *cellModel = self.devices[indexPath.row];
    TYVagueDevice *device = cellModel.device;
    [cell loadDataWithImageName:nil title:[NSString stringWithFormat:kStrDeviceIDFormat,device.id] detailTitle:[NSString stringWithFormat:kStrAssetIDFormat,device.assetID] canSelect:NO];
    if (cellModel.iconUrl) {
        [cell loadDataWithImageUrl:[NSString stringWithFormat:kIconUrlWithIconName, cellModel.iconUrl] defaultImageName:@"deviceDefalut"];
    } else {
        [self.deviceManager queryDeviceInfoOf:device.id completionHandle:^(TYDevice * _Nullable deviceInfo, NSError * _Nullable error) {
            if (deviceInfo) {
                cellModel.iconUrl = deviceInfo.icon;
                [cell loadDataWithImageUrl:[NSString stringWithFormat:kIconUrlWithIconName, cellModel.iconUrl] defaultImageName:@"deviceDefalut"];
            }
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - setter && getter
-(TYDeviceManager *)deviceManager{
    if (!_deviceManager) {
        _deviceManager = [[TYDeviceManager alloc] init];
    }
    return _deviceManager;
}

-(TYAssetManager *)assetManager{
    if (!_assetManager) {
        _assetManager = [[TYAssetManager alloc] init];
    }
    return _assetManager;
}

-(NSMutableArray<TYDeviceCellModel *> *)devices{
    if (!_devices) {
        _devices = [NSMutableArray array];
    }
    return _devices;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:@available(iOS 13.0, *) ? UITableViewStyleInsetGrouped : UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = HexRGB(0xF7F8F9, 1.0f);
        _tableView.backgroundColor = HexRGB(0xF7F8F9, 1.0f);
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[TYDeviceAssetTableViewCell class] forCellReuseIdentifier:[TYDeviceAssetTableViewCell cellIdentifier]];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionPull)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

@end
