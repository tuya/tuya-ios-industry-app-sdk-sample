//
//  TYDeviceManagerBaseCell.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYDeviceManagerBaseCell.h"
#import <Masonry/Masonry.h>

@interface TYDeviceManagerBaseCell ()



@end

@implementation TYDeviceManagerBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 16.0f, 0, 16.0f);
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *arrayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        [self.contentView addSubview:arrayImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(16);
            make.width.height.mas_equalTo(48);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(_iconImageView.mas_right).offset(12);
        }];
        [arrayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(22);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-28);
        }];
        
    }
    return self;
}

- (void)loadDataWithImage:(UIImage *)image title:(NSString *)title {
    self.iconImageView.image = image;
    self.nameLabel.text = title;
}

@end
