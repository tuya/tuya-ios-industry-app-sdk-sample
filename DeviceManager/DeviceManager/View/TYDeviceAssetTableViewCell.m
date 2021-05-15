//
//  TYDeviceAssetTableViewCell.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYDeviceAssetTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+webCache.h>

@interface TYDeviceAssetTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *arrayImageView;

@end

@implementation TYDeviceAssetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.textColor = HexRGB(0x333333, 1.0f);
        [self.contentView addSubview:_nameLabel];
        
        self.detailLabel = [[UILabel alloc] init];        
        _detailLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_detailLabel];
        
        self.arrayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        [self.contentView addSubview:_arrayImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(16);
            make.width.height.mas_equalTo(48);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView).offset(-10);
            make.left.mas_equalTo(_iconImageView.mas_right).offset(12);
            make.bottom.mas_equalTo(self.contentView.mas_centerY);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
        }];
        [_arrayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(22);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-28);
        }];
    }
    return self;
}

- (void)loadDataWithImageName:(NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle {
    _iconImageView.image = [UIImage imageNamed:imageName];
    _nameLabel.text = title;
    _detailLabel.text = detailTitle;
}

- (void)loadDataWithImageName:(NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle canSelect:(BOOL)canSelect {
    [self loadDataWithImageName:imageName title:title detailTitle:detailTitle];
    _arrayImageView.hidden = !canSelect;
    if (!canSelect) {
        [@[_nameLabel,_detailLabel] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrayImageView);
        }];
    } else {
        [@[_nameLabel,_detailLabel] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrayImageView.mas_left).offset(-5);
        }];
    }
}

- (void)loadDataWithImageUrl:(NSString *)imageUrl defaultImageName:(NSString *)defaultImageName{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:defaultImageName]];
}

+ (NSString *)cellIdentifier {
    return @"TYDeviceAssetTableViewCell";
}

@end
