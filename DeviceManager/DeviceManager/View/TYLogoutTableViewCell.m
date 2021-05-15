//
//  TYLogoutTableViewCell.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYLogoutTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TYLogoutTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation TYLogoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:24];
        [self.contentView addSubview:_nameLabel];
        
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.text = kStrUsername;
        subLabel.textColor = HexRGB(0x666666, 1);
        subLabel.font = [UIFont systemFontOfSize:14];
        subLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:subLabel];
        
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.layer.cornerRadius = 8;
        _logoutButton.layer.borderWidth = 1;
        _logoutButton.layer.borderColor = HexRGB(0xFF4300, 1).CGColor;
        [_logoutButton setTitleColor:HexRGB(0xFF4300, 1) forState:UIControlStateNormal];
        [_logoutButton setTitle:kStrLogout forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_logoutButton];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView).offset(-32);
            make.top.mas_equalTo(self.contentView).offset(16);
            make.height.mas_equalTo(34);
        }];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(271);
            make.height.mas_equalTo(52);
            make.top.mas_equalTo(subLabel.mas_bottom).offset(12);
        }];
        
    }
    return self;
}

- (void)loadDataWithUsername:(NSString *)username {
    _nameLabel.text = username;
}

- (void)logoutButtonAction {
    if (self.logoutBlock) {
        self.logoutBlock();
    }
}

+ (NSString *)cellIdentifier {
    return @"TYLogoutTableViewCell";
}

@end
