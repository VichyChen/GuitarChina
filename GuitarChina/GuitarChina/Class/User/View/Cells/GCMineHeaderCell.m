//
//  GCMineHeaderCell.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMineHeaderCell.h"

@interface GCMineHeaderCell()

@property (nonatomic, strong) UIView *separatorViewBottom;

@end

@implementation GCMineHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImage.frame = CGRectMake(15, 10, 80, 80);
    self.userLabel.frame = CGRectMake(110, 15, ScreenWidth - 125, 25);
    self.levelLabel.frame = CGRectMake(110, 55, ScreenWidth - 125, 25);
    self.separatorViewBottom.frame = CGRectMake(0, 99.5, ScreenWidth, 0.5);
}

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.separatorViewBottom];
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero
                                   contentMode:UIViewContentModeScaleAspectFit];
        _avatarImage.layer.cornerRadius = 5;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.backgroundColor = [GCColor grayColor3];
    }
    return _avatarImage;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont boldSystemFontOfSize:17]
                                 textColor:[GCColor blueColor]];
    }
    return _userLabel;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [UIView createLabel:CGRectZero
                                    text:@""
                                    font:[UIFont systemFontOfSize:15]
                               textColor:[GCColor grayColor3]];
    }
    return _levelLabel;
}

- (UIView *)separatorViewBottom {
    if (!_separatorViewBottom) {
        _separatorViewBottom = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorViewBottom.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorViewBottom;
}

@end
