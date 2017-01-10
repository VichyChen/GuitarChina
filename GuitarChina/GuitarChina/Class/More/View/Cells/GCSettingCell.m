//
//  GCSettingCell.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCSettingCell.h"

@interface GCSettingCell()

@property (nonatomic, strong) UIView *separatorViewBottom;

@end

@implementation GCSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.clipsToBounds = YES;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.leftImageView.frame = CGRectMake(15, 12, 20, 20);
    self.titleLabel.frame = CGRectMake(15, 0, ScreenWidth - 30, 44);
    self.valueLabel.frame = CGRectMake(15, 0, ScreenWidth - 30 - 20, 44);
    self.separatorViewBottom.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);
}

- (void)configureView {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.separatorViewBottom];
}

#pragma mark - Getters

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIView createImageView:CGRectZero
                                   contentMode:UIViewContentModeScaleAspectFill];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UIView createLabel:CGRectZero
                                    text:@""
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[GCColor fontColor]];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [UIView createLabel:CGRectZero
                                     text:@""
                                     font:[UIFont systemFontOfSize:16]
                                textColor:[GCColor fontColor]];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}

- (UIView *)separatorViewBottom {
    if (!_separatorViewBottom) {
        _separatorViewBottom = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorViewBottom.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorViewBottom;
}

@end
