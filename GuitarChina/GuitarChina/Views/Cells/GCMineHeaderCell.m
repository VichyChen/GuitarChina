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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImage.frame = CGRectMake(15, 10, 80, 80);
    self.userLabel.frame = CGRectMake(110, 10, ScreenWidth - 125, 25);
    self.separatorViewBottom.frame = CGRectMake(0, 99, ScreenWidth, 1);
}

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.separatorViewBottom];
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero
                                   contentMode:UIViewContentModeScaleAspectFit];
        _avatarImage.layer.cornerRadius = 5;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.backgroundColor = [UIColor GCLightGrayColor];
    }
    return _avatarImage;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UIView createLabel:CGRectZero
                                      text:@"陈大捷"
                                      font:[UIFont boldSystemFontOfSize:17]
                                 textColor:[UIColor GCBlueColor]];
    }
    return _userLabel;
}

- (UIView *)separatorViewBottom {
    if (!_separatorViewBottom) {
        _separatorViewBottom = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorViewBottom.backgroundColor = [UIColor GCGrayLineColor];
    }
    return _separatorViewBottom;
}

@end
