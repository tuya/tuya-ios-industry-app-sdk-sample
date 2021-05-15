//
//  TYAssetManagementViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYAssetManagementViewController.h"
#import "TYDeviceAssetTableViewCell.h"
#import "TYLoginDefine.h"
#import <MJRefresh/MJRefresh.h>
#import "TYButton.h"

@interface TYAssetManagementViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <TYVagueAsset *> *assetArray;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, copy) NSString *projectName;

@property (nonatomic, assign) NSInteger lastRowKey;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) TYButton *chooseButton;

@end

@implementation TYAssetManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configView];
    
    @weakify(self)
    [self requestAssetDataWithAssetID:self.asset.id completionHandle:^(TYActionableAssetsRequestResult *result) {
        @strongify(self)
        self.assetArray = result.assets.mutableCopy;
        self.hasMore = result.hasMoreResult;
        self.projectName = result.projectName;
        [self.tableView reloadData];
    }];
}

- (void)configView {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = self.navTitle;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.frame;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.chooseButton];
    
    _bottomView.hidden = !_canSelect;
    [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(26);
        make.right.mas_equalTo(self.view).offset(-26);
        make.top.mas_equalTo(_bottomView).offset(16);
        make.height.mas_equalTo(52);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(118);
        make.width.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)requestAssetDataWithAssetID:(NSString *)assetID completionHandle:(void (^) (TYActionableAssetsRequestResult *result))completionHandle {
    TYAssetManager *manager = [[TYAssetManager alloc] init];
    [manager queryAssetsWithParentAssetID:assetID pageNumber:_lastRowKey pageSize:100 completionHandle:^(TYActionableAssetsRequestResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            completionHandle(result);
        }
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)chooseButtonAction {
    [[NSUserDefaults standardUserDefaults] setObject:self.asset.id forKey:kCurrentAssetID];
    [[NSUserDefaults standardUserDefaults] setObject:self.asset.name forKey:kCurrentAssetName];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refreshData {
    if (_hasMore) {
        @weakify(self)
        [self requestAssetDataWithAssetID:self.asset.id completionHandle:^(TYActionableAssetsRequestResult *result) {
            @strongify(self)
            [self.assetArray addObjectsFromArray:result.assets];
            self.hasMore = result.hasMoreResult;
            self.lastRowKey += 20;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
                self.tableView.mj_footer = nil;
            }];
        }];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
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
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 50, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[TYDeviceAssetTableViewCell class] forCellReuseIdentifier:[TYDeviceAssetTableViewCell cellIdentifier]];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (TYButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [TYButton buttonWithType:UIButtonTypeCustom];
        [_chooseButton setBackgroundColor:HexRGB(0xFF4800, 1)];
        _chooseButton.layer.cornerRadius = 8;
        [_chooseButton setTitle:kStrSelectCurrentAsset forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(chooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_chooseButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 26 * 2, 52.0f)];
    }
    return _chooseButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYDeviceAssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TYDeviceAssetTableViewCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    TYVagueAsset *asset = _assetArray[indexPath.row];
    [cell loadDataWithImageName:@"asset_list" title:asset.name detailTitle:[NSString stringWithFormat:kStrAssetIDFormat, asset.id]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYVagueAsset *asset = _assetArray[indexPath.row];

    TYAssetManagementViewController *assetVC = [[TYAssetManagementViewController alloc] init];
    assetVC.navTitle = asset.name;
    assetVC.asset = asset;
    assetVC.canSelect = YES;
    [self.navigationController pushViewController:assetVC animated:YES];
}



@end
